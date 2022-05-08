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
        const request = {
            text: 'SELECT * FROM filter_person($1)',
            values: [nir],
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
 * Récupération d'une personne par son NIR et son mot de passe
 * @param nir Le NIR (aussi appelé numéro de sécurité sociale)
 * @param password Le mot de passe
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetByIdAndPassword = (nir, password) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM person WHERE prs_nir = $1 AND prs_password = $2',
            values: [nir, password],
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
 * Vérifie si la personne a le droit ou non pour un role donné
 * @param nir Le NIR de la personne
 * @param code Le code du role
 * @returns {Promise<unknown>}
 * @constructor
 */
const IsGranted = (nir, code) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM is_granted($1, $2)',
            values: [nir, code],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res.is_granted)
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
                const request = {
                    text: 'INSERT INTO person (prs_nir, prs_firstname, prs_lastname, prs_email, prs_password, prs_birthday, prs_address_street, twn_code_insee, sex_id, prf_id) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)',
                    values: [person.nir, person.firstname, person.lastname, person.email, person.password, person.birthday, person.address_street, person.town, person.sex, person.profile],
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

export {Person, GetById, Add, GetByIdAndPassword, IsGranted}
