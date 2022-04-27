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
 * Vérifie si la manifestation éxiste
 * @param id Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (id) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM manifestation WHERE man_id = $1',
            values: [id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res.count > 0)
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
        const request = {
            text: 'INSERT INTO manifestation (man_name, man_date_start, man_date_end, man_object, man_security_description, man_nb_person_estimate, man_url_document_signed) VALUES ($1, $2, $3, $4, $5, $6, $7)',
            values: [manifestation.name, manifestation.date_start, manifestation.date_end,
                        manifestation.object, manifestation.security_description, manifestation.nb_person_estimate,
                        manifestation.url_document_signed],
        }
        pool.query(request, (error, _) => {
            if (error) {
                console.error(error)
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
        IfExists(id).then((result) => {
            if (result) {
                if (result.is_aborted) {
                    resolve(true)
                }
                const request = {
                    text: 'UPDATE manifestation SET man_date_aborted = $1, man_is_aborted = true, man_reason_aborted = $2 WHERE man_id = $3',
                    values: [new Date(), reason, id],
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

/**
 * Récupère toutes les manifestations
 * @param includeAborted Inclure les manifestations annulées
 * @param nir Les manifestations pour une personne
 * @param id L'id de la manifestation'
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (includeAborted = false, nir = null, id = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_manifestation($1, $2, $3)',
            values: [nir, includeAborted, id],
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

export default {Manifestation, Add, Aborted, Get}



