import {Manifestation} from "../models/manifestation.mjs";
import manifestant from "../models/manifestant.mjs";
import {OptionManifestation} from "../models/option-manifestation.mjs"
import geoCtrl from "./geography.controller.mjs"
import {Step} from "../models/step.mjs"
import {ResponseApi} from "../models/response-api.mjs";
import {Vote} from "../models/vote.mjs";

/**
 * Ajoute une nouvelle manifestation
 * @returns {Promise<unknown>}
 * @constructor
 * @param manifJson
 */
const AddManifestation = (manifJson) => {
    return new Promise((resolve, _) => {
        if (!manifJson) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!manifJson.name || !manifJson.object) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!manifJson.date_start || !manifJson.date_end) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let manifestation = new Manifestation()
            Object.assign(manifestation, manifJson)
            manifestation.Add().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Manifestation has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This manifestation already existed"))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            new Manifestation().Aborted(id, reason).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This manifestation not exist"))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    })
}

/**
 * Récupère toutes les manifestations
 * @param includeAborted Inclure les manifestations annulées
 * @param nir Les manifestations pour une personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAllManifestations = (includeAborted = false, nir = null) => {
    return new Promise((resolve, _) => {
        new Manifestation().Get(includeAborted, nir).then(async (res) => {
            for (let i = 0; i < res.length; i++) {
                res[i].steps = await new Step().GetAll(res[i].id)
                res[i].options = await new OptionManifestation().GetAll(res[i].id)
            }
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if(e.code === '23503') {
                resolve(new ResponseApi().InitBadRequest(e.message))
                return
            }
            resolve(new ResponseApi().InitInternalServer(e))
        })
    })
}

/**
 * Participation à une manifestation
 * @param nir Le NIR du manifestant
 * @param id_manifestation L'Id de la manifestation
 * @constructor
 */
const Participate = (nir, id_manifestation) => {
    return new Promise((resolve, _) => {
        if (!nir || !id_manifestation) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            manifestant.Add(nir, id_manifestation).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("You participate."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("You already participate"))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    })
}

/**
 * Récupère la liste des options pour une manifestation
 * @param id_manifestation L'Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetOptions = (id_manifestation) => {
    return new Promise((resolve, _) => {
        if (!id_manifestation) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            new OptionManifestation().GetAll(id_manifestation).then((res) => {
                resolve(new ResponseApi().InitData(res))
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

/**
 * Ajoute une nouvelle option à une manifestation
 * @returns {Promise<unknown>}
 * @constructor
 * @param optJson
 */
const AddOption = (optJson) => {
    return new Promise((resolve, _) => {
        if (!optJson || !optJson.name || !optJson.id_manifestation) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let option = new OptionManifestation()
            Object.assign(option, optJson)
            option.Add().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Option has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This option already existed"))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    })
}

/**
 * Supprime une option de manifestation existante
 * @param id L'Id de l'option à supprimer
 * @returns {Promise<unknown>}
 * @constructor
 */
const DeleteOption = (id) => {
    return new Promise((resolve, _) => {
        if (!id) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let option = new OptionManifestation()
            option.id = id
            option.Delete().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This option does not existed"))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

/**
 * Ajoute une nouvelle étape à une manifestation
 * @param stp Etape de la manifestation à ajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddStep = (stp) => {
    return new Promise(async (resolve, _) => {
        if (stp === null) {
            resolve(new ResponseApi().InitMissingParameters())
        }
        let step = Object.assign(new Step(), stp);
        if (!step || !step.address_street || !step.date_arrived) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!step.town_code_insee || !step.id_step_type || !step.id_manifestation) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            try {
                let coordinates = await geoCtrl.GetLocationFromAddress(step.address_street, step.town_code_insee)
                if(coordinates !== null) {
                    step.latitude = coordinates.latitude
                    step.longitude = coordinates.longitude
                }
            } catch (e) {
                console.error(e)
            }
            step.Add(stp).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Step has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This step already existed"))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    })
}

/**
 * Supprime une étape de manifestation existante
 * @param id L'Id de l'étape à supprimer
 * @returns {Promise<unknown>}
 * @constructor
 */
const DeleteStep = (id) => {
    return new Promise((resolve, _) => {
        if (!id) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let step = new Step()
            step.id = id
            step.Delete().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This step does not existed"))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

/**
 * Récupère la liste des étapes pour une manifestation
 * @param id_manifestation L'Id de la manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetSteps = (id_manifestation) => {
    return new Promise((resolve, _) => {
        if (!id_manifestation) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            new Step().GetAll(id_manifestation).then((res) => {
                resolve(new ResponseApi().InitData(res))
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

export default {
    AddManifestation,
    AbortedManifestation,
    GetAllManifestations,
    Participate,
    GetOptions,
    AddOption,
    DeleteOption,
    AddStep,
    DeleteStep,
    GetSteps
}




