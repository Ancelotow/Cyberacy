import {pool} from "../middlewares/postgres.mjs";

class Meeting {
    id
    name
    object
    description
    date_start
    nb_time
    is_aborted
    reason_aborted
    nb_place
    nb_place_vacant
    street_address
    link_twitch
    id_political_party
    town_code_insee
}

/**
 * Ajoute un nouveau meeting
 * @param meeting Le nouveau meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (meeting) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO meeting (mee_name, mee_object, mee_description, mee_date_start, mee_nb_time, mee_nb_place, mee_address_street, mee_link_twitch, pop_id, twn_code_insee) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)',
            values: [meeting.name, meeting.object, meeting.description, meeting.date_start, meeting.nb_time, meeting.nb_place, meeting.address_street, meeting.link_twitch, meeting.id_political_party, meeting.town_code_insee],
        }
        pool.query(request, (error, _) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

/**
 * Si le meeting éxiste
 * @param id L'id du meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (id) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM meeting WHERE mee_id = $1',
            values: [id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                if (res && res.count > 0) {
                    resolve(true)
                } else {
                    resolve(false)
                }
            }
        });
    });
}

/**
 * Annule un meeting
 * @param id L'id du meeting
 * @param reason La raison de l'annulation
 * @returns {Promise<unknown>}
 * @constructor
 */
const Aborted = (id, reason) => {
    return new Promise((resolve, reject) => {
        IfExists(id).then((result) => {
            if (result) {
                const request = {
                    text: 'UPDATE meeting SET mee_is_aborted = true, mee_reason_aborted = $1, mee_date_aborted = now() WHERE mee_id = $2 AND mee_is_aborted = false',
                    values: [id, reason],
                }
                pool.query(request, (error, _) => {
                    if (error) {
                        reject(error)
                    } else {
                        resolve(true)
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            reject(e)
        });
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
const Get = (town = null, idPoliticalParty = null, nir = null, includeAborted = false, includeCompleted = true) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_meeting($1, $2, $3, $4, $5)',
            values: [town, idPoliticalParty, nir, includeAborted, includeCompleted],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

export default {Meeting, IfExists, Add, Aborted, Get}
