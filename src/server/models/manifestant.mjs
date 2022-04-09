import {pool} from "../middlewares/postgres.mjs";
import {FormaterDate} from "../middlewares/formatter.mjs";

class Manifestant {
    nir
    id_manifestation
    date
}

/**
 * Récupère le manifestant par son NIR et la manifestation
 * @param nir Le NIR du participant
 * @param id_manifestation L'Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (nir, id_manifestation) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT prs_nir as nir,
                                man_id  as id_manifestation,
                                mnf_date as date
                         FROM manifestant
                         WHERE prs_nir = '${nir}'
                           AND man_id = ${id_manifestation}`
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
 * Ajoute un manifestant à une manifestation
 * @param nir Le NIR du manifestant
 * @param id_manifestation L'Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (nir, id_manifestation) => {
    return new Promise((resolve, reject) => {
        GetById(nir, id_manifestation).then((result) => {
            if (!result) {
                const request = `INSERT INTO manifestant (prs_nir, man_id, mnf_date)
                                 VALUES (${nir}, ${id_manifestation}, now())`
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

export default {GetById, Add}
