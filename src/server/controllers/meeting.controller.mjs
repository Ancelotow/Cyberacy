import {Meeting} from "../models/meeting.mjs";
import participantMod from "../models/participant.mjs";
import geoCtrl from "./geography.controller.mjs";
import {Town} from "../models/town.mjs";
import {ResponseApi} from "../models/response-api.mjs";

/**
 * Ajout d'un nouveau meeting
 * @returns {Promise<unknown>}
 * @constructor
 * @param meetingJson
 */
const AddMeeting = (meetingJson) => {
    return new Promise(async (resolve, _) => {
        if (!meetingJson) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!meetingJson.name || !meetingJson.object) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!meetingJson.date_start || !meetingJson.id_political_party) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let meeting = new Meeting()
            Object.assign(meeting, meetingJson)
            try {
                let coordinates = await geoCtrl.GetLocationFromAddress(meeting.street_address, meeting.town_code_insee)
                if (coordinates !== null) {
                    meeting.latitude = coordinates.latitude
                    meeting.longitude = coordinates.longitude
                }
            } catch (e) {
                console.error("Error coordinates", e)
            }
            meeting.Add().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Meeting has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This meeting already existed."))
                }
            }).catch((e) => {
                if (e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            new Meeting().Aborted(id, reason).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This meeting not existed or already aborted."))
                }
            }).catch((e) => {
                if (e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
 * @param includeFinished
 * @param id
 * @param onlyMine
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMeeting = (town = null, idPoliticalParty = null, nir = null, includeAborted = false, includeCompleted = true, includeFinished = false, id = null, onlyMine = false) => {
    return new Promise((resolve, _) => {
        new Meeting().Get(town, idPoliticalParty, nir, includeAborted, includeCompleted, includeFinished, id, onlyMine).then(async (res) => {
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if (e.code === '23503') {
                resolve(new ResponseApi().InitBadRequest(e.message))
                return
            }
            resolve(new ResponseApi().InitInternalServer(e))
        })
    });
}

/**
 * Récupère un meeting par son ID
 * @param nir Le NIR de l'utilisateur
 * @param id L'ID du meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMeetingById = (nir, id) => {
    return new Promise((resolve, _) => {
        if (id === null) {
            resolve(new ResponseApi().InitMissingParameters())
            return
        }
        new Meeting().GetById(nir, id).then(async (res) => {
            if (res != null) {
                res.town = await new Town().GetById(res.town_code_insee)
            }
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if (e.code === '23503') {
                resolve(new ResponseApi().InitBadRequest(e.message))
                return
            }
            resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            participantMod.Add(nir, idMeeting).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Participant has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This participant not existed."))
                }
            }).catch((e) => {
                if (e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            participantMod.Aborted(nir, idMeeting, reason).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This participant not existed or already aborted."))
                }
            }).catch((e) => {
                if (e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

/**
 * Récupère des informations sur les participants
 * @param nir
 * @param idMeeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetInfoParticipant = (nir, idMeeting) => {
    return new Promise((resolve, _) => {
        if (!nir || !idMeeting) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            new Meeting().GetParticipantInfo(nir, idMeeting).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(res))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This participant not existed."))
                }
            }).catch((e) => {
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

/**
 * Retourne si un meeting existe par son UUID
 * @param uuid Le UUID d'un meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfMeetingExistByUUID = (uuid) => {
    return new Promise((resolve, _) => {
        if (uuid === null) {
            resolve(new ResponseApi().InitMissingParameters())
            return
        }
        new Meeting().IfExistsWithUUID(uuid).then(async (res) => {
            resolve(new ResponseApi().InitOK({is_exist: res}))
        }).catch((e) => {
            if (e.code === '23503') {
                resolve(new ResponseApi().InitBadRequest(e.message))
                return
            }
            resolve(new ResponseApi().InitInternalServer(e))
        })
    });
}

export default {
    AddParticipant,
    AddMeeting,
    AbortedMeeting,
    GetMeeting,
    AbortedParticipant,
    GetMeetingById,
    GetInfoParticipant,
    IfMeetingExistByUUID
}
