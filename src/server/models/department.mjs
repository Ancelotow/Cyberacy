import {pool} from "../middlewares/postgres.mjs";

class Department {
    code
    name
    region_code_insee
}

/**
 * Récupère les départements
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        let request = `SELECT dpt_code       as code,
                              dpt_name       as name,
                              reg_code_insee as region_code_insee
                       FROM department`
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

export default {Department, GetAll}
