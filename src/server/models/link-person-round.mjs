import {pool} from "../middlewares/postgres.mjs";

class LinkPersonRound {
    id_vote
    num_round
    nir
    date_vote
}

/**
 * Vérifie si la personne à déjà voté pour un vote donné
 * @param idVote L'id du vote
 * @param nir Le NIR du votant
 * @param numRound Le numéro du tour de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (idVote, numRound, nir) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM link_person_round WHERE vte_id = $1 AND prs_nir = $2 AND rnd_num = $3',
            values: [idVote, nir, numRound],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                if (res && res.count > 0) {
                    resolve(true)
                } else {
                    resolve(false)
                }
            }
        });
    });
}

export default {LinkPersonRound, IfExists}
