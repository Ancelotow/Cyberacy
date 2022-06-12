import {pool} from "../middlewares/postgres.mjs";

class Step {
    id
    address_street
    date_arrived
    is_delete
    id_manifestation
    id_step_type
    town_code_insee
}

/**
 * Ajoute une nouvelle étape pour une manifestation
 * @param step L'étape rajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (step) => {
    return new Promise((resolve, reject) => {
        const request = `INSERT INTO step (stp_address_street, stp_date_arrived, tst_id, twn_code_insee, man_id)
                         VALUES ('${step.address_street}', '${step.date_arrived}', ${step.id_step_type},
                                 '${step.town_code_insee}', ${step.id_manifestation})`
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
 * Récupère une étape de manifestation
 * @param id L'Id de l'étape
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (id) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT stp_id             as id,
                                stp_address_street as address_street,
                                twn_code_insee     as town_code_insee,
                                man_id             as id_manifestation,
                                tst_id             as id_step_type
                         FROM step
                         WHERE stp_id = ${id}
                           AND stp_is_delete = false`
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
 * Supprime une étape de manifestation existante
 * @param id L'Id de l'étape
 * @returns {Promise<unknown>}
 * @constructor
 */
const Delete = (id) => {
    return new Promise((resolve, reject) => {
        GetById(id).then((result) => {
            if (result) {
                const request = `UPDATE step
                                 SET stp_is_delete = true
                                 WHERE stp_id = ${id}`
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
 * Récupère toutes les étapes pour une manifestation
 * @param id_manifestation L'id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = (id_manifestation = null) => {
    return new Promise((resolve, reject) => {
        let request = `SELECT stp_id             as id,
                                stp_address_street as address_street,
                                twn_code_insee     as town_code_insee,
                                man_id             as id_manifestation,
                                tst_id             as id_step_type
                         FROM step
                         WHERE man_id = ${id_manifestation}
                           AND stp_is_delete = false`
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

export default {GetAll, Delete, Add, Step}
