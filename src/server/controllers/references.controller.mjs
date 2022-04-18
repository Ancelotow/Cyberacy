import type_step from "../models/step-type.mjs";
import sex from "../models/sexe.mjs";

/**
 * Récupère la liste des types d'étapes
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetTypeStep = () => {
    return new Promise((resolve, _) => {
        type_step.GetAll().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Récupère la liste des civilités
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetSex = () => {
    return new Promise((resolve, _) => {
        sex.GetAll().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

export default {GetTypeStep, GetSex}
