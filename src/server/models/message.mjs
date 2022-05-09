import {pool} from "../middlewares/postgres.mjs";

class Message {
    id
    message
    date_published
    id_thread
    id_member
}

/**
 * Récupère la liste des messages pour un thread donné
 * @param nir Le NIR de la personne
 * @param idThread L'ID du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (nir, idThread) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_message($1, $2)',
            values: [nir, idThread],
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
 * Ajoute un nouveau message
 * @param message Le message
 * @param idThread L'ID du thread
 * @param idMember L'ID du membre
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (message, idThread, idMember) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO message(msg_message, thr_id, mem_id) VALUES($1, $2, $3)',
            values: [message, idThread, idMember],
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

export default {Message, Add, Get}
