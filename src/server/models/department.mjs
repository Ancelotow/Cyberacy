import {pool} from "../middlewares/postgres.mjs";

class Department {
    code
    name
    region_code_insee
    id_color
    color = null
}

/**
 * Récupère les départements
 * @returns {Promise<unknown>}
 * @constructor
 */
Department.prototype.GetAll = function() {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_department()',
            values: [],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listDepts = []
                result.rows.forEach(e => listDepts.push(Object.assign(new Department(), e)));
                resolve(listDepts)
            }
        });
    });
}

/**
 * Ajoute un nouveau département
 * @returns {Promise<unknown>}
 * @constructor
 */
Department.prototype.Add = function() {
    return new Promise((resolve, reject) => {
        this.GetById(this.code).then((result) => {
            if (!result) {
                const request = {
                    text: 'INSERT INTO department (dpt_code, dpt_name, reg_code_insee) VALUES ($1, $2, $3)',
                    values: [this.code, this.name, this.region_code_insee],
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
 * Récupère un département par son code
 * @param code Code département
 * @returns {Promise<unknown>}
 * @constructor
 */
Department.prototype.GetById = function(code) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_department($1, null)',
            values: [code],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? Object.assign(new Department(), result.rows[0]) : null
                resolve(res)
            }
        });
    });
}

/**
 * Récupère les départements par régions
 * @param code_insee Code INSEE de la région
 * @returns {Promise<unknown>}
 * @constructor
 */
Department.prototype.GetByRegion = function(code_insee) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_department(null, $1)',
            values: [code_insee],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listDepts = []
                result.rows.forEach(e => listDepts.push(Object.assign(new Department(), e)));
                resolve(listDepts)
            }
        });
    });
}

export {Department}
