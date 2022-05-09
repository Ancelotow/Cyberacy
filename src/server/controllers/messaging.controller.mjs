import threadMod from "../models/thread.mjs";
import messageMod from "../models/message.mjs";
import memberMod from "../models/member.mjs";

/**
 * Ajoute un nouveau thread
 * @param thread Le nouveau thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddThread = (thread) => {
    return new Promise(async (resolve, _) => {
        if (!thread) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!thread.name || !thread.id_political_party) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            threadMod.Add(thread).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Thread has been created."})
                } else {
                    resolve({status: 400, data: "This thread already existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Supprime un thread existant
 * @param id L'id du thread à supprimer
 * @returns {Promise<unknown>}
 * @constructor
 */
const DeleteThread = (id) => {
    return new Promise(async (resolve, _) => {
        if (!id) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            threadMod.Delete(id).then((res) => {
                if (res) {
                    resolve({status: 200, data: "Thread has been deleted."})
                } else {
                    resolve({status: 400, data: "This thread not existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Change le thread principal d'un parti politique
 * @param id L'id du thread
 * @param id_political_party L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const ChangeMainThread = (id, id_political_party) => {
    return new Promise(async (resolve, _) => {
        if (!id || !id_political_party) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            threadMod.ChangeMainThread(id, id_political_party).then((res) => {
                if (res) {
                    resolve({status: 200, data: "The main thread has been updated."})
                } else {
                    resolve({status: 400, data: "This main thread not existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Modifie un thread
 * @param thread Le thread à modifier
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateThread = (thread) => {
    return new Promise(async (resolve, _) => {
        if (!thread || !thread.id) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!thread.id || !thread.name || !thread.id_political_party) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            threadMod.Update(thread).then((res) => {
                if (res) {
                    resolve({status: 200, data: "Thread has been updated."})
                } else {
                    resolve({status: 400, data: "This thread not existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Récupère les threads selon les filtres et les droits
 * @param nir Le NIR de la personne
 * @param onlyMine Récupérer uniquement les threads où la personne est membre
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetThread = (nir, onlyMine = true) => {
    return new Promise((resolve, _) => {
        threadMod.Get(nir, onlyMine).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            if(e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Publie un nouveau message
 * @param nir Le NIR de la personne qui publie le message
 * @param idThread L'ID du thread
 * @param message Le message à publier
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddMessage = (nir, idThread, message) => {
    return new Promise(async (resolve, _) => {
        if (!idThread || !message) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            const idMember = await memberMod.GetMemberIdByNIR(nir, idThread);
            if (idMember === null) {
                resolve({status: 400, data: "You are not in this thread."})
            } else {
                messageMod.Add(message, idThread, idMember).then((res) => {
                    if (res) {
                        resolve({status: 201, data: "The message has been published."})
                    } else {
                        resolve({status: 400, data: "This message already published."})
                    }
                }).catch((e) => {
                    if(e.code === '23503') resolve({status: 400, data: e.message})
                    resolve({status: 500, data: e})
                })
            }

        }
    });
}

/**
 * Retourne les messages sur un thread donné
 * @param nir Le NIR de la personne
 * @param idThread L'ID du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMessage = (nir, idThread) => {
    return new Promise((resolve, _) => {
        messageMod.Get(nir, idThread).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

export default {AddThread, UpdateThread, DeleteThread, ChangeMainThread, GetThread, AddMessage, GetMessage}
