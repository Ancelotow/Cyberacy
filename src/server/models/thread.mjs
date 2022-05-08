import {pool} from "../middlewares/postgres.mjs";

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
}

/**
 * Ajoute un nouveau thread
 * @param thread Le nouveau thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (thread) => {
    return new Promise((resolve, reject) => {
        const is_private = (thread.is_private == null) ? false : thread.is_private
        const request = {
            text: 'insert into thread(thr_name, thr_description, thr_is_private, thr_url_logo, pop_id) values ($1, $2, $3, $4, $5)',
            values: [thread.name, thread.description, is_private, thread.url_logo, thread.id_political_party],
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
 * Vérifie si un thread éxiste ou non selon l'id
 * @param id L'id du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (id) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM thread WHERE thr_id = $1',
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
 * Change le thread principale
 * @param id L'id du thread
 * @param id_political_party L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const ChangeMainThread = (id, id_political_party) => {
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
 * @param id L'id du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const Delete = (id) => {
    return new Promise((resolve, reject) => {
        IfExists(id).then(async (result) => {
            if (result) {
                const request = {
                    text: 'UPDATE thread SET thr_is_delete = true, thr_date_delete = now() WHERE thr_id = $1 AND thr_is_delete = false',
                    values: [id],
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
 * @param thread Le thread à modifié
 * @returns {Promise<unknown>}
 * @constructor
 */
const Update = (thread) => {
    return new Promise((resolve, reject) => {
        IfExists(thread.id).then(async (result) => {
            if (result) {
                const is_private = (thread.is_private == null) ? false : thread.is_private
                const request = {
                    text: 'UPDATE thread SET thr_name = $1, thr_description = $2, thr_is_private = $3, thr_url_logo = $4 WHERE thr_id = $5',
                    values: [thread.name, thread.description, is_private, thread.url_logo, thread.id],
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

export default {Thread, Add, ChangeMainThread, Delete, IfExists, Update}
