import manifestation from "../models/manifestation.mjs";
import manifestant from "../models/manifestant.mjs";
import option from "../models/option-manifestation.mjs"
import step from "../models/step.mjs"

/**
 * Ajoute une nouvelle manifestation
 * @param manif La nouvelle manifestation
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddManifestation = (manif) => {
    return new Promise((resolve, _) => {
        if (!manif) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!manif.name || !manif.object) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!manif.date_start || !manif.date_end) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            manifestation.Add(manif).then((res) => {
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
            manifestation.Aborted(id, reason).then((res) => {
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
 * @param nir Les manifestations pour une personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAllManifestations = (includeAborted = false, nir = null) => {
    return new Promise((resolve, _) => {
        manifestation.Get(includeAborted, nir).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else {
            manifestant.Add(nir, id_manifestation).then((res) => {
                if (res) {
                    resolve({status: 201, data: "You participate."})
                } else {
                    resolve({status: 400, data: "You already participate."})
                }
            }).catch((e) => {
                console.error(e)
                resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else {
            option.GetAll(id_manifestation).then((res) => {
                const code = (res) ? 200 : 204;
                resolve({status: code, data: res})
            }).catch((e) => {
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Ajoute une nouvelle option à une manifestation
 * @param opt Option de la manifestation à ajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddOption = (opt) => {
    return new Promise((resolve, _) => {
        if (!opt || !opt.name || !opt.id_manifestation) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            option.Add(opt).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Option has been created."})
                } else {
                    resolve({status: 400, data: "This option already existed."})
                }
            }).catch((e) => {
                console.error(e)
                resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else {
            option.Delete(id).then((res) => {
                if (res) {
                    resolve({status: 200, data: "The option has been deleted."})
                } else {
                    resolve({status: 400, data: "This option does not existed."})
                }
            }).catch((e) => {
                resolve({status: 500, data: e})
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
    return new Promise((resolve, _) => {
        if (!stp || !stp.address_street || !stp.date_arrived) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!stp.town_code_insee || !stp.id_step_type || !stp.id_manifestation) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            step.Add(stp).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Step has been created."})
                } else {
                    resolve({status: 400, data: "This step already existed."})
                }
            }).catch((e) => {
                console.error(e)
                resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else {
            step.Delete(id).then((res) => {
                if (res) {
                    resolve({status: 200, data: "The step has been deleted."})
                } else {
                    resolve({status: 400, data: "This step does not existed."})
                }
            }).catch((e) => {
                resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else {
            step.GetAll(id_manifestation).then((res) => {
                const code = (res) ? 200 : 204;
                resolve({status: code, data: res})
            }).catch((e) => {
                resolve({status: 500, data: e})
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




