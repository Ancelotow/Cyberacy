import {pool} from "../middlewares/postgres.mjs";

class Vote {
    id
    name
    nb_voter
    id_type_vote
    town_code_insee
    department_code
    reg_code_insee
    id_political_party
    region = null
    department = null
    town = null
    id_type
    name_type
    id_election

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

class ResultVote {
    id_choice
    libelle_choice
    nb_voice
    perc_with_abstention
    perc_without_abstention
    id_vote
    name_vote
    num_round
    name_round
    id_color
    color = null
}

/**
 * Ajoute un nouveau vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Vote.prototype.Add = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO vote (vte_name, twn_code_insee, dpt_code, reg_code_insee, pop_id, elc_id, vte_nb_voter) VALUES ($1, $2, $3, $4, $5, $6, $7)',
            values: [this.name, this.id_type_vote, this.town_code_insee, this.department_code, this.reg_code_insee, this.id_political_party, this.id_election, this.nb_voter],
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
 * @param idElection L'id de l'élection
 * @param includeFinish Inclus les votes passés
 * @param includeFuture Inclus les votes futur
 * @returns {Promise<unknown>}
 * @constructor
 */
Vote.prototype.Get = function (nir, idElection, includeFinish = false, includeFuture = true) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_vote($1, $2, $3, $4)',
            values: [nir, idElection, includeFinish, includeFuture],
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

Vote.prototype.GetInProgress = function (nir) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM get_in_progress_vote($1)',
            values: [nir],
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
 * Récupère le détail d'un vote par son ID
 * @param id L'ID du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Vote.prototype.GetById = function (id) {
    return new Promise((resolve, reject) => {
        const request = {
            text: `
                select vte.vte_id         as id,
                       vte_name           as name,
                       vte.vte_nb_voter   as nb_voter,
                       vte.twn_code_insee as town_code_insee,
                       vte.dpt_code       as department_code,
                       vte.reg_code_insee as reg_code_insee,
                       vte.pop_id         as id_political_party,
                       vte.elc_id         as id_election,
                       e.tvo_id           as id_type
                from vote vte
                         join election e on e.elc_id = vte.elc_id
                where vte.vte_id = $1
                limit 1
            `,
            values: [id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                if (result.rows.length > 0) {
                    resolve(Object.assign(new Vote(), result.rows[0]))
                } else {
                    resolve(null)
                }
            }
        });
    });
}

/**
 * Récupère les absentions
 * @param num_round
 * @param id_type_vote Tri par type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetStatsAbsentions = (num_round, id_type_vote = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM vote_get_absention($1, $2)',
            values: [num_round, id_type_vote],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                if (res != null) {
                    for (let i = 0; i < res.length; i++) {
                        res[i].perc_abstention = parseFloat(res[i].perc_abstention)
                    }
                }
                resolve(res)
            }
        });
    });
}

/**
 * Récupère les participations
 * @param num_round
 * @param id_type_vote Tri par type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetStatsParticipations = (num_round, id_type_vote = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM vote_get_participation($1, $2)',
            values: [num_round, id_type_vote],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                if (res != null) {
                    for (let i = 0; i < res.length; i++) {
                        res[i].perc_participation = parseFloat(res[i].perc_participation)
                    }
                }
                resolve(res)
            }
        });
    });
}

/**
 * Récupère les résultats des votes
 * @returns {Promise<unknown>}
 * @constructor
 * @param idVote
 * @param numRound
 */
const GetResults = (idVote, numRound) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM vote_get_results($1, $2)',
            values: [idVote, numRound],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listResult = []
                result.rows.forEach(e => listResult.push(Object.assign(new ResultVote(), e)));
                resolve(listResult)
            }
        });
    });
}

export {Vote, GetStatsAbsentions, GetStatsParticipations, GetResults}
