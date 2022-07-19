import {pool} from "../middlewares/postgres.mjs";

class Member {
    id
    firstname
    lastname
    date_join
    date_left
    is_left
    mute_thread
    id_thread
    id_adherent
}

/**
 * Récupération des membres d'un thread
 * @param nir Le NIR de l'utilisateur
 * @param idThread L'id du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (nir, idThread) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_membres($1, $2)',
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
 * Ajoute un nouveau membre à un thread
 * @param idAdherent L'id de l'adhérent rejoignant le thread
 * @param idThread L'id du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (idAdherent, idThread) => {
    return new Promise(async (resolve, reject) => {
        const isExisted = await IfExists(idAdherent, idThread)
        if(isExisted) {
            resolve(false)
            return;
        }
        const request = {
            text: 'INSERT INTO member(adh_id, thr_id) VALUES($1, $2)',
            values: [idAdherent, idThread],
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
 * Quitter un thread
 * @param idAdherent L'id de l'adhérent quittant le thread
 * @param idThread L'id du thread à quitter
 * @returns {Promise<unknown>}
 * @constructor
 */
const Left = (idAdherent, idThread) => {
    return new Promise(async (resolve, reject) => {
        const isExisted = await IfExists(idAdherent, idThread)
        if(!isExisted) {
            resolve(false)
        }
        const request = {
            text: 'UPDATE member SET mem_is_left = true WHERE adh_id = $1 AND thr_id = $2 AND mem_is_left = false',
            values: [idAdherent, idThread],
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
 * Mute ou unmute un thread pour un membre
 * @param idMember L'id du membre souhaitant mute/unmute un thread
 * @param mute Mute ou unmute
 * @returns {Promise<unknown>}
 * @constructor
 */
const MuteThread = (idMember, mute = false) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'UPDATE member SET mem_mute_thread = $1 WHERE mem_id = $2',
            values: [mute, idMember],
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
 * Récupère l'id d'un membre par le NIR d'une personne
 * @param nir Le NIR de la personne
 * @param idThread L'ID du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMemberIdByNIR = (nir, idThread) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM get_id_member_by_nir($1, $2)',
            values: [nir, idThread],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res.get_id_member_by_nir)
            }
        });
    });
}

/**
 * Vérifie s'il éxiste un membre déjà présent sur un thread
 * @param idAdherent L'id de l'adhérent
 * @param idThread L'id du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (idAdherent, idThread) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM member WHERE adh_id = $1 AND thr_id = $2 AND mem_is_left = false',
            values: [idAdherent, idThread],
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


export default {Member, GetMemberIdByNIR, Get, Add, MuteThread, IfExists, Left}
