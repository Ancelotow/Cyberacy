import {FormaterDate} from "../middlewares/formatter.mjs";
import {pool} from "../middlewares/postgres.mjs";

class Vote {
    id
    name
    date_start
    date_end
    num_round
    nb_voter
    id_type_vote
    town_code_insee
    department_code
    reg_code_insee
    political_party_id
}

/**
 * Ajoute un nouveau vote
 * @param vote Le nouveau vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (vote) => {
    return new Promise((resolve, reject) => {
        const town = (vote.town_code_insee == null) ? null : `'${vote.town_code_insee}'`
        const department = (vote.department_code == null) ? null : `'${vote.department_code}'`
        const region = (vote.reg_code_insee == null) ? null : `'${vote.reg_code_insee}'`
        const political_party = (vote.political_party_id == null) ? null : vote.political_party_id;
        const request = `INSERT INTO vote (vte_name, vte_date_start, vte_date_end,
                                           vte_num_round, vte_nb_voter, tvo_id, twn_code_insee,
                                           dpt_code, reg_code_insee, pop_id)
                         VALUES ('${vote.name}', '${FormaterDate(vote.date_start)}',
                                 '${FormaterDate(vote.date_end)}', ${vote.num_round},
                                 ${vote.nb_voter}, ${vote.id_type_vote},
                                 ${town}, ${department}, ${region}, ${political_party});`
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
