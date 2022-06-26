import {pool} from "../middlewares/postgres.mjs";
import {Town} from "./town.mjs";
import {Department} from "./department.mjs";
import {Region} from "./region.mjs";
import {TypeVote} from "./type-vote.mjs";

class Vote {
    id
    name
    id_type_vote
    town_code_insee
    department_code
    reg_code_insee
    id_political_party
    region = new Region()
    department = new Department()
    town = new Town()
    type_vote = new TypeVote()
    rounds = []
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
Vote.prototype.Add = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO vote (vte_name, tvo_id, twn_code_insee, dpt_code, reg_code_insee, pop_id) VALUES ($1, $2, $3, $4, $5, $6)',
            values: [this.name, this.id_type_vote, this.town_code_insee, this.department_code, this.reg_code_insee, this.id_political_party],
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
Vote.prototype.Get = function(nir, includeFinish = false, includeFuture = true, idTypeVote = null) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_vote($1, $2, $3, $4)',
            values: [nir, includeFinish, includeFuture, idTypeVote],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listVote = []
                result.rows.forEach(e => listVote.push(Object.assign(new Vote(), e)));
                resolve(listVote)
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

/**
 * Récupère les résultats des votes
 * @param id_type_vote Filtrer par types de votes
 * @param id_vote Filtre sur un vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetResults = (id_type_vote = null, id_vote = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM vote_get_results($1, $2)',
            values: [id_type_vote, id_vote],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                for(let i = 0; i < res.length; i++){
                    res[i].perc_without_abstention = parseFloat(res[i].perc_without_abstention)
                    res[i].perc_with_abstention = parseFloat(res[i].perc_with_abstention)
                }
                resolve(res)
            }
        });
    });
}

export {Vote, GetStatsAbsentions, GetStatsParticipations, GetResults}
