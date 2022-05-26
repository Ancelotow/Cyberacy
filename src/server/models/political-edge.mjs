import {pool} from "../middlewares/postgres.mjs";

class PoliticalEdge {
    id
    name
}

/**
 * Récupère tout les bords politiques
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = () => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT poe_id as id, poe_name as name FROM political_edge',
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

export default {PoliticalEdge, Get}
