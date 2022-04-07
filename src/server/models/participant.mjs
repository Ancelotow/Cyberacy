import {pool} from "../middlewares/postgres.mjs";
import {FormaterDate} from "../middlewares/formatter.mjs";

class Participant {
    idMeeting
    nir
    date_joined
    is_aborted
    date_aborted
    reason_aborted
}

/**
 * Récupère le participant
 * @param nir NIR de la personne
 * @param idMeeting Meeting à laquelle participe la personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (nir, idMeeting) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT man_id             as idMeeting,
                                prs_nir            as nir,
                                ptc_date_joined    as date_joined,
                                ptc_is_joined      as is_aborted,
                                ptc_date_aborted   as date_aborted,
                                ptc_reason_aborted as reason_aborted
                         FROM participant
                         WHERE man_id = ${idMeeting}
                         AND prs_nir = '${nir}'`
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res)
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
        GetById(nir, idMeeting).then((result) => {
            if (!result) {
                const request = `INSERT INTO participant (mee_id, )`
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
