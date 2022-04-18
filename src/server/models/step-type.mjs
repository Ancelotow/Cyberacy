import {pool} from "../middlewares/postgres.mjs";

class Step_Type {
    id
    name
}

/**
 * Récupère tout les types d'étapes
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        let request = `SELECT tst_id   as id,
                              tst_name as name
                       FROM type_step`
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

export default {Step_Type, GetAll}
