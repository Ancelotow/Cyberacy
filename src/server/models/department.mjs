import {pool} from "../middlewares/postgres.mjs";

class Department {
    code
    name
    region_code_insee
}

/**
 * Récupère les départements
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        let request = `SELECT dpt_code       as code,
                              dpt_name       as name,
                              reg_code_insee as region_code_insee
                       FROM department`
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
 * Ajoute un nouveau département
 * @param department Le nouveau département
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (department) => {
    return new Promise((resolve, reject) => {
        GetById(department.code).then((result) => {
            if (!result) {
                const request = `INSERT INTO department (dpt_code, dpt_name, reg_code_insee)
                                 VALUES ('${department.code}', '${department.name}', '${department.region_code_insee}');`
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
const GetById = (code) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT dpt_code       as code,
                                dpt_name       as name,
                                reg_code_insee as region_code_insee
                         FROM department
                         WHERE dpt_code = '${code}'`
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
 * Récupère les départements par régions
 * @param code_insee Code INSEE de la région
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetByRegion = (code_insee) => {
    return new Promise((resolve, reject) => {
        let request = `SELECT dpt_code       as code,
                              dpt_name       as name,
                              reg_code_insee as region_code_insee
                       FROM department
                       WHERE reg_code_insee = '${code_insee}'`
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

export default {Department, GetAll, Add, GetByRegion}
