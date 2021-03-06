import {pool} from "../middlewares/postgres.mjs";

class Sex {
    id
    name
}

/**
 * Récupère toutes les civilités
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = () => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT sex_id as id, sex_name as name FROM sex',
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

export default {Sex, Get}
