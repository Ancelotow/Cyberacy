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
Message.prototype.Get = function(nir, idThread) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_message($1, $2)',
            values: [nir, idThread],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listMessages = []
                result.rows.forEach(e => listMessages.push(Object.assign(new Message(), e)));
                resolve(listMessages)
            }
        });
    });
}

/**
 * Ajoute un nouveau message
 * @returns {Promise<unknown>}
 * @constructor
 */
Message.prototype.Add = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO message(msg_message, thr_id, mem_id) VALUES($1, $2, $3)',
            values: [this.message, this.id_thread, this.id_member],
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

export {Message}
