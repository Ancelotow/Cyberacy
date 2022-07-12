import {pool} from "../middlewares/postgres.mjs";
import {Message} from "./message.mjs";

class Thread {
    id
    main
    name
    description
    date_create
    is_delete
    date_delete
    is_private
    url_logo
    id_political_party
    fcm_topic
    lastMessage = null
}

/**
 * Ajoute un nouveau thread
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.Add = function () {
    return new Promise((resolve, reject) => {
        const is_private = (this.is_private == null) ? false : this.is_private
        const request = {
            text: 'insert into thread(thr_name, thr_description, thr_is_private, thr_url_logo, pop_id) values ($1, $2, $3, $4, $5)',
            values: [this.name, this.description, is_private, this.url_logo, this.id_political_party],
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
 * Récupère les threads selon les filtres et les droits
 * @param nir Le NIR de la personne
 * @param onlyMine Récupérer uniquement les threads où la personne est membre
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.Get = function (nir, onlyMine = true) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_thread($1, $2)',
            values: [nir, onlyMine],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listThreads = []
                result.rows.forEach(e => listThreads.push(Object.assign(new Thread(), e)));
                resolve(listThreads)
            }
        });
    });
}

/**
 * Récupère un thread par son ID
 * @param nir Le NIR de l'utilisateur
 * @param id L'ID du Thread
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.GetById = function (nir, id) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_thread($1, true) WHERE id = $2',
            values: [nir, id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? Object.assign(new Thread(), result.rows[0]) : null
                resolve(res)
            }
        });
    });
}

/**
 * Récupère les topic de l'utilisateur sur les thread pour les Notifications PUSH
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.GetMyFCMTopic = function (nir) {
    return new Promise((resolve, reject) => {
        const request = {
            text: `
                select thr_fcm_topic as fcm_topic
                from thread thr
                         join member mem on thr.thr_id = mem.thr_id and mem_mute_thread = false and mem_is_left = false
                         join adherent adh on mem.adh_id = adh.adh_id and prs_nir = $1 and adh_is_left = false
            `,
            values: [nir],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                resolve(result.rows)
            }
        });
    });
}

/**
 * Vérifie si un thread éxiste ou non selon l'id
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.IfExists = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM thread WHERE thr_id = $1',
            values: [this.id],
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
 * Change le thread principale
 * @param id L'id du thread
 * @param id_political_party L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.ChangeMainThread = function (id, id_political_party) {
    return new Promise((resolve, reject) => {
        IfExists(id).then(async (result) => {
            if (result) {
                const requestOld = {
                    text: 'UPDATE thread SET thr_main = false WHERE pop_id = $1',
                    values: [id_political_party],
                }
                try {
                    await pool.query(requestOld);
                } catch (error) {
                    reject(error)
                }
                const request = {
                    text: 'UPDATE thread SET thr_main = true WHERE thr_id = $1 AND pop_id = $2',
                    values: [id, id_political_party],
                }
                pool.query(request, (error, _) => {
                    if (error) {
                        console.error(error)
                        reject(error)
                    } else {
                        resolve(true)
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            console.error(e)
            reject(e)
        });
    });
}

/**
 * Supprimer un thread
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.Delete = function () {
    return new Promise((resolve, reject) => {
        this.IfExists().then(async (result) => {
            if (result) {
                const request = {
                    text: 'UPDATE thread SET thr_is_delete = true, thr_date_delete = now() WHERE thr_id = $1 AND thr_is_delete = false',
                    values: [this.id],
                }
                pool.query(request, (error, _) => {
                    if (error) {
                        console.error(error)
                        reject(error)
                    } else {
                        resolve(true)
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            console.error(e)
            reject(e)
        });
    });
}

/**
 * Modifie un thread
 * @returns {Promise<unknown>}
 * @constructor
 */
Thread.prototype.Update = function () {
    return new Promise((resolve, reject) => {
        this.IfExists().then(async (result) => {
            if (result) {
                const is_private = (this.is_private == null) ? false : this.is_private
                const request = {
                    text: 'UPDATE thread SET thr_name = $1, thr_description = $2, thr_is_private = $3, thr_url_logo = $4 WHERE thr_id = $5',
                    values: [this.name, this.description, is_private, this.url_logo, this.id],
                }
                pool.query(request, (error, _) => {
                    if (error) {
                        console.error(error)
                        reject(error)
                    } else {
                        resolve(true)
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            console.error(e)
            reject(e)
        });
    });
}

export {Thread}
