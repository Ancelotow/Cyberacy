import {pool} from "../middlewares/postgres.mjs";

class Choice{
    id
    name
    choice_order
    nb_vote
    description
    num_round
    id_vote
    candidat
    candidat_nir
}

/**
 * Ajoute un nouveau choix pour un vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Choice.prototype.Add = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO choice (cho_name, cho_order, rnd_num, vte_id, cho_description, prs_nir) VALUES ($1, $2, $3, $4, $5, $6)',
            values: [this.name, this.choice_order, this.num_round, this.id_vote, this.description, this.candidat_nir],
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
 * Récupère la liste des choix pour un tour de vote donné
 * @param nir Le NIR de l'utilisateur
 * @param numRound Le numéro du tour de vote
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Choice.prototype.Get = function(nir, numRound, idVote) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_choice($1, $2, $3)',
            values: [nir, idVote, numRound],
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

/**
 * Ajoute un votant sur le choix sélectionné
 * @param nir Le NIR du votant
 * @param numRound Le numéro du tour de vote
 * @param idVote L'id du vote
 * @param idChoice L'id du choix
 * @returns {Promise<unknown>}
 * @constructor
 */
Choice.prototype.AddVoter = function(nir) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT add_vote_to_choice($1, $2, $3, $4)',
            values: [nir, this.id, this.num_round, this.id_vote],
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

export {Choice}
