import {pool} from "../middlewares/postgres.mjs";

class Profile {
    id
    name
    description
    date_create
    can_deleted = false
}

/**
 * Retourne la liste des profiles
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
Profile.prototype.Get = function (nir) {
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
 * @returns {Promise<unknown>}
 * @constructor
 */
Profile.prototype.Add = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO profile (prf_name, prf_description, prf_can_deleted) VALUES ($1, $2, true)',
            values: [this.name, this.description],
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
 * @returns {Promise<unknown>}
 * @constructor
 */
Profile.prototype.Delete = function () {
    return new Promise((resolve, reject) => {
        this.IfExists(this.id).then((result) => {
            if (result) {
                const request = {
                    text: `UPDATE profile
                           SET prf_is_delete   = true,
                               prf_date_delete = now()
                           WHERE prf_id = $1`,
                    values: [this.id],
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
Profile.prototype.IfExists = (id) => {
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

export {Profile}
