import {pool} from "../middlewares/postgres.mjs";

class Town {
    code_insee
    name
    zip_code
    nb_resident
    department_code
}

/**
 * Récupère la liste des communes
 * @returns {Promise<unknown>}
 * @constructor
 */
Town.prototype.GetAll = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_town()',
            values: [],
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
 * Recupère une commune par son code INSEE
 * @param code_insee Code INSEE de la commune
 * @returns {Promise<unknown>}
 * @constructor
 */
Town.prototype.GetById = function (code_insee)  {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_town($1, null)',
            values: [code_insee],
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
 * Ajoute une nouvelle commune
 * @param town La nouvelle commune
 * @returns {Promise<unknown>}
 * @constructor
 */
Town.prototype.Add = function () {
    return new Promise((resolve, reject) => {
        this.GetById(this.code_insee).then((result) => {
            if (!result) {
                const request = {
                    text: 'INSERT INTO town (twn_code_insee, twn_name, twn_zip_code, twn_nb_resident, dpt_code) VALUES ($1, $2, $3, $4, $5)',
                    values: [this.code_insee, this.name, this.zip_code, this.nb_resident, this.department_code],
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
            console.error(e)
            reject(e)
        });
    });
}

/**
 * Récupère les communes par départements
 * @param code Code département
 * @returns {Promise<unknown>}
 * @constructor
 */
Town.prototype.GetByDepartment = function (code) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_town(null, $1)',
            values: [code],
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

export {Town}
