import {pool} from "../middlewares/postgres.mjs";

class TypeVote {
    id
    name
}

/**
 * Récupère tout les types de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        let request = `SELECT tvo_id   as id,
                              tvo_name as name
                       FROM type_vote`
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

export default {TypeVote, GetAll}
