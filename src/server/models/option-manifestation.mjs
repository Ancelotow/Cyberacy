import {pool} from "../middlewares/postgres.mjs";

class OptionManifestation {
    id
    name
    description
    is_delete
    id_manifestation
}

/**
 * Récupérer une option de manifestation
 * @param id L'Id de l'option de manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (id) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT omn_id          as id,
                                omn_name        as name,
                                omn_description as description,
                                omn_is_delete   as is_delete,
                                man_id          as id_manifestation
                         FROM option_manifestation
                         WHERE omn_id = ${id}
                           AND omn_is_delete = false`
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
 * Ajoute une nouvelle option pour une manifestation
 * @param option L'option de manifestation à rajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (option) => {
    return new Promise((resolve, reject) => {
        const request = `INSERT INTO option_manifestation (omn_name, omn_description, man_id)
                         VALUES ('${option.name}', '${option.description}', ${option.id_manifestation})`
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
 * Supprime une option de manifestation existante
 * @param id L'Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const Delete = (id) => {
    return new Promise((resolve, reject) => {
        GetById(id).then((result) => {
            if (result) {
                const request = `UPDATE option_manifestation SET omn_is_delete = true WHERE omn_id = ${id}`
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
 * Récupère toutes les options de manifestations
 * @param id_manifestation L'Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = (id_manifestation = null) => {
    return new Promise((resolve, reject) => {
        let request = `SELECT omn_id          as id,
                                omn_name        as name,
                                omn_description as description,
                                omn_is_delete   as is_delete,
                                man_id          as id_manifestation
                         FROM option_manifestation
                         WHERE omn_is_delete = false`
        if (!id_manifestation) {
            request += ` AND man_id = ${id_manifestation}`
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

export default {GetById, Add, Delete, GetAll}
