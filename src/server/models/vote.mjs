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

class StatsAbsention {
    nb_abstention
    perc_abstention
    id_vote
    name_vote
    num_round
    name_round
    id_type_vote
    name_type_vote
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
            values: [vote.name, vote.id_type_vote, vote.town_code_insee, vote.department_code, vote.reg_code_insee, vote.id_political_party],
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
 * Récupère la liste des votes selon les filtres
 * @param nir Le NIR de l'utilisateur
 * @param includeFinish Inclus les votes passés
 * @param includeFuture Inclus les votes futur
 * @param idTypeVote L'id du type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (nir, includeFinish = false, includeFuture = true, idTypeVote = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_vote($1, $2, $3, $4)',
            values: [nir, includeFinish, includeFuture, idTypeVote],
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
 * Récupère les absentions
 * @param id_type_vote Tri par type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetStatsAbsentions = (id_type_vote = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM vote_get_absention($1)',
            values: [id_type_vote],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                for(let i = 0; i < res.length; i++){
                    res[i].perc_abstention = parseFloat(res[i].perc_abstention)
                }
                resolve(res)
            }
        });
    });
}

/**
 * Récupère les participations
 * @param id_type_vote Tri par type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetStatsParticipations = (id_type_vote = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM vote_get_participation($1)',
            values: [id_type_vote],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                for(let i = 0; i < res.length; i++){
                    res[i].perc_participation = parseFloat(res[i].perc_participation)
                }
                resolve(res)
            }
        });
    });
}

export default {Vote, Add, Get, GetStatsAbsentions, GetStatsParticipations}
