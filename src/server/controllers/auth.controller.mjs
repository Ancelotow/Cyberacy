import {Person, Add} from '../models/person.mjs'

/**
 * Enregistre une nouvelle personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const Register = (person) => {
    return new Promise((resolve, reject) => {
        if (person == null) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (person.nir == null || person.firstname == null || person.lastname == null) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (person.sex == null || person.town == null) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            Add(person).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Person has been created."})
                } else {
                    resolve({status: 400, data: "This person already existed."})
                }
            }).catch((e) => {
                resolve({status: 500, data: e})
            })
        }
    });
}

export {Register}
