import {pool} from "../middlewares/postgres.mjs";

class Profile {
    id
    name
    description
    date_create
}

/**
 * Retourne la liste des profiles
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (nir) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_profile($1)',
            values: [nir],
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
 * Ajoute un nouveau profil
 * @param name Le nom du profil
 * @param description La description du profile
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (name, description) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO profile (prf_name, prf_description) VALUES ($1, $2)',
            values: [name, description],
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
 * Suppression d'un profile existant
 * @param id
 * @returns {Promise<unknown>}
 * @constructor
 */
const Delete = (id) => {
    return new Promise((resolve, reject) => {
        IfExists(id).then((result) => {
            if (result) {
                const request = {
                    text: `UPDATE profile SET prf_is_delete = true, prf_date_delete = now() WHERE prf_id = $1`,
                    values: [id],
                }
                pool.query(request, (error, _) => {
                    if (error) {
                        reject(error)
                    } else {
                        resolve(true)
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            reject(e)
        });
    });
}

/**
 * Vérifie si un profile éxiste ou pas
 * @param id L'id du profile
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (id) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM profile WHERE prf_id = $1',
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

export default {
    Profile,
    Get,
    IfExists,
    Delete,
    Add
}
