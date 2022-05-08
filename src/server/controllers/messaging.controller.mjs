import threadMod from "../models/thread.mjs";

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
                console.error(e)
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
                console.error(e)
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
                console.error(e)
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
                console.error(e)
                resolve({status: 500, data: e})
            })
        }
    });
}

export default {AddThread, UpdateThread, DeleteThread, ChangeMainThread}
