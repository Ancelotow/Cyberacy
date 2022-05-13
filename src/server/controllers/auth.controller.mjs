import {Person, Add, GetByIdAndPassword, IsGranted} from '../models/person.mjs'
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
        } else if (person.sex == null || person.town_code_insee == null) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            Add(person).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Person has been created."})
                } else {
                    resolve({status: 400, data: "This person already existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Authentification d'un utilisateur
 * @param nir Le NIR (aussi appelé numéro de sécurité sociale)
 * @param password Le mot de passe
 * @param code_role Le code du role
 * @returns {Promise<unknown>}
 * @constructor
 */
const Authentication = async (nir, password, code_role) => {
    return new Promise(async (resolve, _) => {
        if(nir == null || password == null) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (code_role == null) {
            resolve({status: 500, data: "Missing code role."})
        }
        try{
            const res = await GetByIdAndPassword(nir, password);
            if(!res) {
                resolve({status: 401, data: "This NIR and password not matching."})
            }
            const isGranted = await IsGranted(nir, code_role);
            if(!isGranted) {
                resolve({status: 401, data: "You are not allowed to access at this ressources."})
            }
            resolve({status: 200, data: GenerateToken(nir)})
        } catch(error) {
            resolve({status: 500, data: error})
        }
        GetByIdAndPassword(nir, password).then((res) => {
            if(!res) {
                resolve({status: 401, data: "This NIR and password not matching."})
            }
            resolve({status: 200, data: GenerateToken(nir)})
        }).catch((e) => {
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
