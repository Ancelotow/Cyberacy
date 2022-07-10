import {pool} from "../middlewares/postgres.mjs";
import {Manifestation} from "./manifestation.mjs";

class OptionManifestation {
    id
    name
    description
    is_delete
    id_manifestation
}

/**
 * Ajoute une nouvelle option pour une manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
OptionManifestation.prototype.Add = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO option_manifestation (omn_name, omn_description, man_id) VALUES($1, $2, $3)',
            values: [this.name, this.description, this.id_manifestation],
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
 * Supprime une option de manifestation existante
 * @returns {Promise<unknown>}
 * @constructor
 */
OptionManifestation.prototype.Delete = () => {
    return new Promise((resolve, reject) => {
        this.IfExists().then((result) => {
            if (result) {
                const request = `UPDATE option_manifestation SET omn_is_delete = true WHERE omn_id = ${id}`
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
 * Récupère toutes les options de manifestations
 * @param id_manifestation L'Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
OptionManifestation.prototype.GetAll = (id_manifestation = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_options($1)',
            values: [id_manifestation],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listOptions = []
                result.rows.forEach(e => listOptions.push(Object.assign(new OptionManifestation(), e)));
                resolve(listOptions)
            }
        });
    });
}

OptionManifestation.prototype.IfExists = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM option_manifestation WHERE omn_id = $1',
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

export {OptionManifestation}
