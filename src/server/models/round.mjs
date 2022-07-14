import {pool} from "../middlewares/postgres.mjs";

class Round {
    num
    id_vote
    name
    date_start
    date_end
    is_voted = false

    choices = []
}

/**
 * Ajoute un nouveau tour de vote
 * @param round Le tour à ajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
Round.prototype.Add = function () {
    return new Promise(async (resolve, reject) => {
        const isExisted = await this.IfExists()
        if (isExisted) {
            resolve(false)
        }
        const request = {
            text: 'INSERT INTO round (rnd_num, rnd_name, rnd_date_start, rnd_date_end, vte_id) VALUES ($1, $2, $3, $4, $5)',
            values: [this.num, this.name, this.date_start, this.date_end, this.id_vote],
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
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
Round.prototype.Get = function (nir, idVote) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_round($1, $2)',
            values: [nir, idVote],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listRounds = []
                result.rows.forEach(e => listRounds.push(Object.assign(new Round(), e)));
                resolve(listRounds)
            }
        });
    });
}

/**
 * Vérifie si le tour de vote existe déjà
 * @returns {Promise<unknown>}
 * @constructor
 */
Round.prototype.IfExists = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM round WHERE rnd_num = $1 AND vte_id = $2',
            values: [this.num, this.id_vote],
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

export {Round}
