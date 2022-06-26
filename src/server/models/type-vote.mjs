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
TypeVote.prototype.Get = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT tvo_id as id, tvo_name as name FROM type_vote',
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

export {TypeVote}
