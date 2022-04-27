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
const Get = () => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT tst_id as id, tst_name as name FROM type_step',
            values: [],
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

export default {Step_Type, Get}
