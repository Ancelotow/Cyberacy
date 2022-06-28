import type_step from "../models/step-type.mjs";
import sex from "../models/sexe.mjs";
import {TypeVote} from "../models/type-vote.mjs";
import political_edge from "../models/political-edge.mjs";

/**
 * Récupère la liste des types d'étapes
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetTypeStep = () => {
    return new Promise((resolve, _) => {
        type_step.Get().then((res) => {
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
        sex.Get().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Récupère la liste des types de votes
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetTypeVote = () => {
    return new Promise((resolve, _) => {
        new TypeVote().Get().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Récupère tous les bords politiques
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetPoliticalEdge = () => {
    return new Promise((resolve, _) => {
        political_edge.Get().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

export default {GetTypeStep, GetSex, GetTypeVote, GetPoliticalEdge}
