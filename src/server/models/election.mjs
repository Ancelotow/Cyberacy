import {pool} from "../middlewares/postgres.mjs";

class Election {
    id
    name
    date_start
    date_end
    id_type_vote
    type_vote = null
    votes = []
}

/**
 * Ajoute une nouvelle élection
 * @returns {Promise<unknown>}
 * @constructor
 */
Election.prototype.Add = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO election (elc_name, elc_date_start, elc_date_end, tvo_id) VALUES ($1, $2, $3, $4)',
            values: [this.name, this.date_start, this.date_end, this.id_type_vote],
        }
        pool.query(request, (error, _) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

/**
 * Récupère la liste des élections
 * @param nir Le NIR de l'utilisateur
 * @param idElection L'id de l'élection
 * @param includeFinish Inclure les élections finis
 * @param includeFuture Inclure les prochaines élections
 * @returns {Promise<unknown>}
 * @constructor
 */
Election.prototype.Get = function(nir, idElection = null, includeFinish = false, includeFuture = true) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_election($1, $2, $3, $4)',
            values: [nir, idElection, includeFinish, includeFuture],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listElection = []
                result.rows.forEach(e => listElection.push(Object.assign(new Election(), e)));
                resolve(listElection)
            }
        });
    });
}

export {Election}
