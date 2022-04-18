import {pool} from "../middlewares/postgres.mjs";

class Town {
    code_insee
    name
    zip_code
    nb_resident
    department_code
}

/**
 * Récupère la liste des communes
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        let request = `SELECT twn_code_insee  as code_insee,
                              twn_name        as name,
                              twn_zip_code    as zip_code,
                              twn_nb_resident as nb_resident,
                              dpt_code        as department_code
                       FROM town`
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
 * Recupère une commune par son code INSEE
 * @param code_insee Code INSEE de la commune
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (code_insee) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT twn_code_insee  as code_insee,
                                twn_name        as name,
                                twn_zip_code    as zip_code,
                                twn_nb_resident as nb_resident,
                                dpt_code        as department_code
                         FROM town
                         WHERE twn_code_insee = '${code_insee}'`
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
 * Ajoute une nouvelle commune
 * @param town La nouvelle commune
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (town) => {
    return new Promise((resolve, reject) => {
        GetById(town.code_insee).then((result) => {
            if (!result) {
                const request = `INSERT INTO town (twn_code_insee, twn_name, twn_zip_code, twn_nb_resident, dpt_code)
                                 VALUES ('${town.code_insee}', '${town.name}', '${town.zip_code}', ${town.nb_resident},
                                         '${town.department_code}');`
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

export default {Town, GetAll, Add}
