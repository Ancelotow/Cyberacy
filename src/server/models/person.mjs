import {pool} from "../middlewares/postgres.mjs"

class Person {
    nir
    firstname
    lastname
    email
    password
    birthday
    address_street
    town
    sex
    profile
}

/**
 * Récupération d'une personne par son NIR
 * @param nir Le NIR (aussi appelé numéro de sécurité sociale)
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetById = (nir) => {
    return new Promise((resolve, reject) => {
        const request = `SELECT *
                         FROM person
                         WHERE prs_nir = '${nir}'`
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
 * Ajoute une nouvelle personne si elle n'éxiste pas
 * @param person La nouvelle personne à ajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (person) => {
    return new Promise((resolve, reject) => {
        GetById(person.nir).then((result) => {
            if (!result) {
                const request = `INSERT INTO person (prs_nir, prs_firstname, prs_lastname, prs_email, prs_password,
                                                     prs_birthday, prs_address_street, twn_code_insee, sex_id, prf_id)
                                 VALUES ('${person.nir}', '${person.firstname}', '${person.lastname}', '${person.email}
                                         ', '${person.password}', '${person.birthday}', '${person.address_street}',
                                         '${person.town}', ${person.sex}, ${person.profile});`
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
 * Supprime une personne
 * @param nir Le NIR (aussi appelé numéro de sécurité sociale)
 * @returns {Promise<unknown>}
 * @constructor
 */
const Delete = (nir) => {
    return new Promise((resolve, reject) => {
        GetById(nir).then((result) => {
            if (!result) {
                const request = `DELETE
                                 FROM person
                                 WHERE prs_nir = '${nir}'`
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


export {Person, GetById, Add}
