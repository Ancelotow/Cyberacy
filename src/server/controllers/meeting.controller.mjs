import meetingMod from "../models/meeting.mjs";
import participantMod from "../models/participant.mjs";

/**
 * Ajout d'un nouveau meeting
 * @param meeting Le nouveau meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddMeeting = (meeting) => {
    return new Promise((resolve, _) => {
        if (!meeting) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!meeting.name || !meeting.object) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!meeting.date_start || !meeting.id_political_party) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            meetingMod.Add(meeting).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Meeting has been created."})
                } else {
                    resolve({status: 400, data: "This meeting already existed."})
                }
            }).catch((e) => {
                console.error(e)
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
            meetingMod.Aborted(id, reason).then((res) => {
                if (res) {
                    resolve({status: 200, data: "Meeting has been aborted."})
                } else {
                    resolve({status: 400, data: "This meeting not existed or already aborted."})
                }
            }).catch((e) => {
                console.error(e)
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
        meetingMod.Get(town, idPoliticalParty, nir, includeAborted, includeCompleted).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            console.error(e)
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
                console.error(e)
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
                console.error(e)
                resolve({status: 500, data: e})
            })
        }
    });
}

export default {AddParticipant, AddMeeting, AbortedMeeting, GetMeeting, AbortedParticipant}
