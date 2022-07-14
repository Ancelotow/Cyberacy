import type_step from "../models/step-type.mjs";
import sex from "../models/sexe.mjs";
import {TypeVote} from "../models/type-vote.mjs";
import political_edge from "../models/political-edge.mjs";
import {ResponseApi} from "../models/response-api.mjs";
import {Color} from "../models/color.mjs";

/**
 * Récupère la liste des types d'étapes
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetTypeStep = () => {
    return new Promise((resolve, _) => {
        type_step.Get().then((res) => {
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
        })
    });
}

/**
 * Récupère toutes les couleurs
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetColors = () => {
    return new Promise((resolve, _) => {
        new Color().Get().then((res) => {
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
        })
    });
}

export default {GetTypeStep, GetSex, GetTypeVote, GetPoliticalEdge, GetColors}
