import {pool} from "../middlewares/postgres.mjs";
import {FormaterDate} from "../middlewares/formatter.mjs";

class Manifestation {
    id
    name
    date_start
    date_end
    is_aborted
    date_aborted
    date_create
    object
    security_description
    nb_person_estimate
    url_document_signed
    reason_aborted
}

/**
 * Récupère une manifestation par son Id
 * @param id Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (id) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT man_id                   as id,
                                man_name                 as name,
                                man_date_start           as date_start,
                                man_date_end             as date_end,
                                man_is_aborted           as is_aborted,
                                man_date_aborted         as date_aborted,
                                man_date_create          as date_create,
                                man_object               as object,
                                man_security_description as security_description,
                                man_nb_person_estimate   as nb_person_estimate,
                                man_url_document_signed  as url_document_signed,
                                man_reason_aborted       as reason_aborted
                         FROM manifestation
                         WHERE man_id = ${id}`
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
 * Ajoute une nouvelle manifestation
 * @param manifestation La nouvelle manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (manifestation) => {
    return new Promise((resolve, reject) => {
        const request = `INSERT INTO manifestation (man_name, man_date_start, man_date_end,
                                                    man_object, man_security_description, man_nb_person_estimate,
                                                    man_url_document_signed)
                         VALUES ('${manifestation.name}', '${FormaterDate(manifestation.date_start)}',
                                 '${FormaterDate(manifestation.date_end)}', '${manifestation.object}',
                                 '${manifestation.security_description}', ${manifestation.nb_person_estimate},
                                 '${manifestation.url_document_signed}');`
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
 * Annuler une manifestation
 * @param id Id de la manifestation à annuler
 * @param reason La raison de l'annulation
 * @returns {Promise<unknown>}
 * @constructor
 */
const Aborted = (id, reason) => {
    return new Promise((resolve, reject) => {
        GetById(id).then((result) => {
            if (result) {
                if (result.is_aborted) {
                    resolve(true)
                }
                const request = `UPDATE manifestation
                                 SET man_date_aborted   = '${FormaterDate(new Date())}',
                                     man_is_aborted     = true,
                                     man_reason_aborted = '${reason}'
                                 WHERE man_id = ${id}`
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
 * Récupère toutes les manifestations
 * @param includeAborted Inclure les manifestations annulées
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = (includeAborted) => {
    return new Promise((resolve, reject) => {
        let request = `SELECT man_id                   as id,
                              man_name                 as name,
                              man_date_start           as date_start,
                              man_date_end             as date_end,
                              man_is_aborted           as is_aborted,
                              man_date_aborted         as date_aborted,
                              man_date_create          as date_create,
                              man_object               as object,
                              man_security_description as security_description,
                              man_nb_person_estimate   as nb_person_estimate,
                              man_url_document_signed  as url_document_signed,
                              man_reason_aborted       as reason_aborted
                       FROM manifestation`
        if (!includeAborted) {
            request += ` WHERE man_is_aborted = false`
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

export {Manifestation, GetById, Add, Aborted, GetAll}



