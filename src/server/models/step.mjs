import {pool} from "../middlewares/postgres.mjs";

export class Step {
    id
    address_street
    date_arrived
    is_delete
    id_manifestation
    id_step_type
    town_code_insee
    latitude
    longitude
}

/**
 * Ajoute une nouvelle étape pour une manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
Step.prototype.Add = () => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO step (stp_address_street, stp_date_arrived, tst_id, twn_code_insee, man_id, stp_latitude, stp_longitude) VALUES ($1, $2, $3, $4, $5, $6, $7)',
            values: [this.address_street, this.date_arrived, this.id_step_type, this.town_code_insee, this.id_manifestation, this.latitude, this.longitude],
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
 * Récupère une étape de manifestation
 * @param id L'Id de l'étape
 * @returns {Promise<unknown>}
 * @constructor
 */
Step.prototype.GetById = () => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'select * from filter_step() where id = $1',
            values: [this.id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res)
            }
        });
    });
}

/**
 * Supprime une étape de manifestation existante
 * @param id L'Id de l'étape
 * @returns {Promise<unknown>}
 * @constructor
 */
Step.prototype.Delete = () => {
    return new Promise((resolve, reject) => {
        this.GetById().then((result) => {
            if (result) {
                const request = {
                    text: 'UPDATE step SET stp_is_delete = true WHERE stp_id = $1',
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
 * Récupère toutes les étapes pour une manifestation
 * @param id_manifestation L'id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
Step.prototype.GetAll = (id_manifestation = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'select * from filter_step($1)',
            values: [id_manifestation],
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
