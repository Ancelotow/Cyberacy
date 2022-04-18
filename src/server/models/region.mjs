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

export default {Region, GetAll}
