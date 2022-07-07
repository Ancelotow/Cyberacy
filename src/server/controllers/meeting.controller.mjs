import {Meeting} from "../models/meeting.mjs";
import participantMod from "../models/participant.mjs";
import {Vote} from "../models/vote.mjs";
import geoCtrl from "./geography.controller.mjs";
import {Town} from "../models/town.mjs";

/**
 * Ajout d'un nouveau meeting
 * @returns {Promise<unknown>}
 * @constructor
 * @param meetingJson
 */
const AddMeeting = (meetingJson) => {
    return new Promise(async (resolve, _) => {
        if (!meetingJson) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!meetingJson.name || !meetingJson.object) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!meetingJson.date_start || !meetingJson.id_political_party) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            let meeting = new Meeting()
            Object.assign(meeting, meetingJson)
            let coordinates = await geoCtrl.GetLocationFromAddress(meeting.street_address, meeting.town_code_insee)
            if(coordinates !== null) {
                meeting.latitude = coordinates.latitude
                meeting.longitude = coordinates.longitude
            }
            meeting.Add().then((res) => {
                if (res) {
                    resolve({status: 201, data: "Meeting has been created."})
                } else {
                    resolve({status: 400, data: "This meeting already existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Annule un meeting
 * @param id L'id du meeting
 * @param reason La raison de l'annulation
 * @returns {Promise<unknown>}
 * @constructor
 */
const AbortedMeeting = (id, reason = null) => {
    return new Promise((resolve, _) => {
        if (!id) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            new Meeting().Aborted(id, reason).then((res) => {
                if (res) {
                    resolve({status: 200, data: "Meeting has been aborted."})
                } else {
                    resolve({status: 400, data: "This meeting not existed or already aborted."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Récupère la liste des meetings
 * @param town La ville
 * @param idPoliticalParty L'id du parti politique
 * @param nir Le NIR du participant
 * @param includeAborted Inclus les meetings annulé
 * @param includeCompleted Inclus les meetings complet
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMeeting = (town = null, idPoliticalParty = null, nir = null, includeAborted = false, includeCompleted = true) => {
    return new Promise((resolve, _) => {
        new Meeting().Get(town, idPoliticalParty, nir, includeAborted, includeCompleted).then(async (res) => {
            const code = (res.length > 0) ? 200 : 204;
            for(let i = 0; i < res.length; i++) {
                if(res[i].town_code_insee != null) {
                    res[i].town = await new Town().GetById(res[i].town_code_insee)
                }
            }
            resolve({status: code, data: res})
        }).catch((e) => {
            if(e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Ajoute un participant à un meeting
 * @param nir Le NIR du participant
 * @param idMeeting L'id du meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddParticipant = (nir, idMeeting) => {
    return new Promise((resolve, _) => {
        if (!nir || !idMeeting) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            participantMod.Add(nir, idMeeting).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Participant has been added."})
                } else {
                    resolve({status: 400, data: "This participant not existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Annuler une participation
 * @param nir Le NIR du participant
 * @param idMeeting L'id du meeting
 * @param reason La raison de l'annulation
 * @returns {Promise<unknown>}
 * @constructor
 */
const AbortedParticipant = (nir, idMeeting, reason = null) => {
    return new Promise((resolve, _) => {
        if (!nir || !idMeeting) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            participantMod.Aborted(nir, idMeeting, reason).then((res) => {
                if (res) {
                    resolve({status: 200, data: "This participation has been aborted."})
                } else {
                    resolve({status: 400, data: "This participant not existed or already aborted."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

export default {AddParticipant, AddMeeting, AbortedMeeting, GetMeeting, AbortedParticipant}
