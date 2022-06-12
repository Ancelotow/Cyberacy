import {pool} from "../middlewares/postgres.mjs";
import {FormaterDate} from "../middlewares/formatter.mjs";

class Participant {
    id_meeting
    nir
    date_joined
    is_aborted
    date_aborted
    reason_aborted
}

/**
 * Récupère les participants
 * @param includeAborted Inclure les participants ayant annulé
 * @param idMeeting Meeting à laquelle participe la personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (idMeeting, includeAborted = false) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_participant($1, $2)',
            values: [idMeeting, includeAborted],
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

/**
 * Si le participant éxiste déjà pour un meeting donné
 * @param idMeeting L'id du meeting
 * @param nir Le NIR du participant
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (idMeeting, nir) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM participant WHERE prs_nir = $1 AND mee_id = $2',
            values: [nir, idMeeting],
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
 * Ajoute un nouveau participant au meeting
 * @param nir
 * @param idMeeting
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (nir, idMeeting) => {
    return new Promise((resolve, reject) => {
        IfExists(idMeeting, nir).then((result) => {
            if (!result) {
                const request = {
                    text: 'INSERT INTO participant (mee_id, prs_nir) VALUES ($1, $2)',
                    values: [idMeeting, nir],
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
 * Annuler sa participation à un meeting
 * @param nir Le NIR du participant
 * @param idMeeting L'id du meeting
 * @param reason Les raisons de l'annulation
 * @returns {Promise<unknown>}
 * @constructor
 */
const Aborted = (nir, idMeeting, reason) => {
    return new Promise((resolve, reject) => {
        IfExists(nir, idMeeting).then((result) => {
            if (result) {
                const request = {
                    text: 'UPDATE participant SET ptc_is_aborted = true, ptc_date_aborted = now(), ptc_reason_aborted = $1 WHERE mee_id = $3 AND prs_nir = $4 AND ptc_is_aborted = false',
                    values: [reason, idMeeting, nir],
                }
                pool.query(request, (error, _) => {
                    if (error) {
                        console.error(error)
                        reject(error)
                    } else {
                        resolve(true)
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            console.error(e)
            reject(e)
        });
    });
}

export default {Participant, Get, Add, IfExists, Aborted}
