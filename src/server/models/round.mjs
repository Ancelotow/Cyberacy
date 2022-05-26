import {pool} from "../middlewares/postgres.mjs";

class Round {
    num
    id_vote
    name
    date_start
    date_end
    nb_voter
}

/**
 * Ajoute un nouveau tour de vote
 * @param round Le tour à ajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (round) => {
    return new Promise(async (resolve, reject) => {
        const isExisted = await IfExists(round.num, round.id_vote)
        if(isExisted){
            resolve(false)
        }
        const request = {
            text: 'INSERT INTO round (rnd_num, rnd_name, rnd_date_start, rnd_date_end, rnd_nb_voter, vte_id) VALUES ($1, $2, $3, $4, $5, $6)',
            values: [round.num, round.name, round.date_start, round.date_end, round.nb_voter, round.id_vote],
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
 * Récupère la liste des tours de votes selon les filtres
 * @param nir Le NIR de l'utilisateur
 * @param includeFinish Inclus les votes passés
 * @param includeFuture Inclus les votes futur
 * @param idTypeVote L'id du type de vote
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (nir, includeFinish = false, includeFuture = true, idTypeVote = null, idVote = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_round($1, $2, $3, $4, $5)',
            values: [nir, includeFinish, includeFuture, idTypeVote, idVote],
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
 * Vérifie si le tour de vote existe déjà
 * @param num Le numéro du tour de vote
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (num, idVote) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM round WHERE rnd_num = $1 AND vte_id = $2',
            values: [num, idVote],
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

export default {Round, Add, Get, IfExists}
