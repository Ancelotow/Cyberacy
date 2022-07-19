import {ResponseApi} from "../models/response-api.mjs";
import {Manifestation} from "../models/manifestation.mjs";
import {Thread} from "../models/thread.mjs";

/**
 * Récupère tout les Topics auxquels l'utilisateur est abonnés (utilisé pour les Notifications PUSH)
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetFCMTopic = (nir) => {
    return new Promise(async (resolve, _) => {
        try{
            let arrTopics = []
            let resManifestation = await new Manifestation().GetMyFCMTopic(nir)
            let resThread = await new Thread().GetMyFCMTopic(nir)
            arrTopics.push(...resManifestation)
            arrTopics.push(...resThread)
            resolve(new ResponseApi().InitData(arrTopics))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    })
}

export default {GetFCMTopic}
