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
        let request = `SELECT twn_code_insee    as code_insee,
                              twn_name          as name,
                              twn_zip_code      as zip_code,
                              twn_nb_resident   as nb_resident,
                              dpt_code          as department_code
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

export default {Town, GetAll}
