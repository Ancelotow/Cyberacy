import {FormaterDate} from "../middlewares/formatter.mjs";
import {pool} from "../middlewares/postgres.mjs";

class Vote {
    id
    name
    id_type_vote
    town_code_insee
    department_code
    reg_code_insee
    id_political_party
}

/**
 * Ajoute un nouveau vote
 * @param vote Le nouveau vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (vote) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO vote (vte_name, tvo_id, twn_code_insee, dpt_code, reg_code_insee, pop_id) VALUES ($1, $2, $3, $4, $5, $6)',
            values: [vote.name, vote.id_type_vote, vote.department_code, vote.reg_code_insee, vote.id_political_party],
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

export default {Add}
