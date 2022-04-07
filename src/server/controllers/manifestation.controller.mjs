import {Manifestation, GetAll, GetById, Add, Aborted} from "../models/manifestation.mjs";

/**
 * Ajoute une nouvelle manifestation
 * @param manifestation La nouvelle manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddManifestation = (manifestation) => {
    return new Promise((resolve, _) => {
        if (!manifestation) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!manifestation.name || !manifestation.object ) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!manifestation.date_start || !manifestation.date_end) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            Add(manifestation).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Manifestation has been created."})
                } else {
                    resolve({status: 400, data: "This manifestation already existed."})
                }
            }).catch((e) => {
                console.error(e)
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Annule une manifestation existante
 * @param id Id de la manifestation à annuler
 * @param reason La raison de l'annulation (optionnel)
 * @returns {Promise<unknown>}
 * @constructor
 */
const AbortedManifestation = (id, reason) => {
    return new Promise((resolve, _) => {
        if (!id) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            Aborted(id, reason).then((res) => {
                if (res) {
                    resolve({status: 200, data: "Manifestation has been aborted."})
                } else {
                    resolve({status: 400, data: "This manifestation not exist."})
                }
            }).catch((e) => {
                resolve({status: 500, data: e})
            })
        }
    })
}

/**
 * Récupère toutes les manifestations
 * @param includeAborted Inclure les manifestations annulées
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAllManifestations = (includeAborted = false) => {
    return new Promise((resolve, _) => {
        GetAll(includeAborted).then((res) => {
            resolve({status: 200, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    })
}

export {AddManifestation, AbortedManifestation, GetAllManifestations}




