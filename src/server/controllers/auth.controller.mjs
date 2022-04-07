import {Person, Add, GetByIdAndPassword} from '../models/person.mjs'
import jwt from "jsonwebtoken"

/**
 * Enregistre une nouvelle personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const Register = (person) => {
    return new Promise((resolve, _) => {
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

/**
 * Authentification d'un utilisateur
 * @param nir Le NIR (aussi appelé numéro de sécurité sociale)
 * @param password Le mot de passe
 * @returns {Promise<unknown>}
 * @constructor
 */
const Authentication = (nir, password) => {
    return new Promise((resolve, _) => {
        if(nir == null || password == null) {
            resolve({status: 400, data: "Missing parameters."})
        }
        GetByIdAndPassword(nir, password).then((res) => {
            if(!res) {
                resolve({status: 401, data: "This NIR and password not matching."})
            }
            resolve({status: 200, data: GenerateToken(nir)})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Génère le JWT token
 * @param nir Le NIR (aussi appelé numéro de sécurité sociale)
 * @returns {*|null}
 * @constructor
 */
const GenerateToken = (nir) => {
    if(!nir) {
        return null
    }
    return jwt.sign({nir}, process.env.TOKEN, { expiresIn: "1d" })
}

export {Register, Authentication}
