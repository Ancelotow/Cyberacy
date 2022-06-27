import {pool} from "../middlewares/postgres.mjs";

class Region {
    code_insee
    name
    id_color
    color = null
}

/**
 * Récupère toutes les régions
 * @returns {Promise<unknown>}
 * @constructor
 */
Region.prototype.GetAll = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_region()',
            values: [],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listRegion = []
                result.rows.forEach(e => listRegion.push(Object.assign(new Region(), e)));
                resolve(listRegion)
            }
        });
    });
}

/**
 * Récupère une région par son code INSEE
 * @param code_insee Code INSEE de la région
 * @returns {Promise<unknown>}
 * @constructor
 */
Region.prototype.GetById = function (code_insee) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_region($1)',
            values: [code_insee],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? Object.assign(new Region(), result.rows[0]) : null
                resolve(res)
            }
        });
    });
}

/**
 * Ajoute une nouvelle région
 * @param region La nouvelle région
 * @returns {Promise<unknown>}
 * @constructor
 */
Region.prototype.Add = function () {
    return new Promise((resolve, reject) => {
        this.GetById(this.code_insee).then((result) => {
            if (!result) {
                const request = {
                    text: 'INSERT INTO region (reg_code_insee, reg_name) VALUES ($1, $2)',
                    values: [this.code_insee, this.name],
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

export {Region}
