import {Person, Add, GetByIdAndPassword, IsGranted} from '../models/person.mjs'
import jwt from "jsonwebtoken"
import {ResponseApi} from "../models/response-api.mjs";

/**
 * Enregistre une nouvelle personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const Register = (person) => {
    return new Promise((resolve, _) => {
        if (person == null) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (person.nir == null || person.firstname == null || person.lastname == null) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (person.sex == null || person.town_code_insee == null) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            Add(person).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Person has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This person already existed."))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                console.error(e)
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
            return
        } else if (code_role == null) {
            resolve(new ResponseApi().InitInternalServer(new Error("Missing code_role")))
            return
        }
        try{
            const res = await GetByIdAndPassword(nir, password);
            if(!res) {
                resolve(new ResponseApi().InitUnauthorized("This NIR and password not matching."))
                return
            }
            const isGranted = await IsGranted(nir, code_role);
            if(!isGranted) {
                resolve(new ResponseApi().InitUnauthorized("You are not allowed to access at this ressources."))
                return
            }
            res.token = GenerateToken(res)
            resolve(new ResponseApi().InitOK(res))
        } catch(error) {
            resolve(new ResponseApi().InitInternalServer(error))
        }
    });
}

/**
 * Génère le JWT token
 * @returns {*|null}
 * @constructor
 * @param person
 */
const GenerateToken = (person) => {
    if(!person) {
        return null
    }
    try{
        return jwt.sign(person, process.env.TOKEN, { expiresIn: "1d" })
    } catch(e) {
        console.log(e)
        throw e
    }
}

export {Register, Authentication}
