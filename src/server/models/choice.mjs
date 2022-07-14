import {pool} from "../middlewares/postgres.mjs";
import {Meeting} from "./meeting.mjs";

class Choice{
    id
    name
    description
    id_vote
    candidat
    candidat_nir
    id_color

    color = null
}

/**
 * Ajoute un nouveau choix pour un vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Choice.prototype.Add = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO choice (cho_name, vte_id, cho_description, prs_nir, clr_id) VALUES ($1, $2, $3, $4, $5)',
            values: [this.name, this.id_vote, this.description, this.candidat_nir, this.id_color],
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
Choice.prototype.Get = function(nir, numRound = null, idVote) {
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
 * Supprime un choix de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Choice.prototype.Delete = function() {
    return new Promise(async (resolve, reject) => {
        let isExist = await this.IfExists(this.id)
        if(!isExist) {
            resolve(false);
            return;
        }
        const request = {
            text: 'DELETE FROM choice WHERE cho_id = $1',
            values: [this.id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

/**
 * Récupère si un choix de vote existe ou non
 * @param id L'id du choix de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Choice.prototype.IfExists = function (id) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM choice WHERE cho_id = $1',
            values: [id],
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

/**
 * Ajoute un votant sur le choix sélectionné
 * @param nir Le NIR du votant
 * @param num_round
 * @returns {Promise<unknown>}
 * @constructor
 */
Choice.prototype.AddVoter = function(nir, num_round) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT add_vote_to_choice($1, $2, $3, $4)',
            values: [nir, this.id, num_round, this.id_vote],
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
