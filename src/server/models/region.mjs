import {pool} from "../middlewares/postgres.mjs";

class Region {
    code_insee
    name
}

/**
 * Récupère toutes les régions
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        let request = `SELECT reg_code_insee as id,
                              reg_name       as name
                       FROM region`
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
 * Récupère une région par son code INSEE
 * @param code_insee Code INSEE de la région
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (code_insee) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT reg_code_insee as code_insee,
                                reg_name       as name
                         FROM region
                         WHERE reg_code_insee = '${code_insee}'`
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
 * Ajoute une nouvelle région
 * @param region La nouvelle région
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (region) => {
    return new Promise((resolve, reject) => {
        GetById(region.code_insee).then((result) => {
            if (!result) {
                const request = `INSERT INTO region (reg_code_insee, reg_name)
                                 VALUES ('${region.code_insee}', '${region.name}');`
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

export default {Region, GetAll, Add}
