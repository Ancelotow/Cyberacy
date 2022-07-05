import threadMod from "../models/thread.mjs";
import {Message} from "../models/message.mjs";
import memberMod from "../models/member.mjs";
import adherentMod from "../models/adherent.mjs";
import {NotificationPush} from "../models/notification-push.mjs";

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
                if (e.code === '23503') resolve({status: 400, data: e.message})
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
                if (e.code === '23503') resolve({status: 400, data: e.message})
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
                if (e.code === '23503') resolve({status: 400, data: e.message})
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
                if (e.code === '23503') resolve({status: 400, data: e.message})
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
        threadMod.Get(nir, onlyMine).then(async (res) => {
            const code = (res) ? 200 : 204;
            if(code === 200) {
                for(let i = 0; i < res.length; i++) {
                    try{
                        let listMessage = await new Message().Get(nir, res[i].id)
                        if(listMessage != null && listMessage.length > 0) {
                            res[i].lastMessage = listMessage[0]
                        }
                    } catch(e) {
                        console.error("Error get messages", e)
                    }
                }
            }
            resolve({status: code, data: res})
        }).catch((e) => {
            if (e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Publie un nouveau message
 * @param person
 * @param idThread L'ID du thread
 * @param msgJson
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddMessage = (person, idThread, msgJson) => {
    return new Promise(async (resolve, _) => {
        if (idThread == null || message == null) {
            resolve({status: 400, data: "Missing parameters."})
        }
        else if (msgJson.message == null) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            const idMember = await memberMod.GetMemberIdByNIR(person.nir, idThread);
            if (idMember === null || idMember === -1) {
                resolve({status: 400, data: "You are not in this thread."})
            } else {
                let message = new Message()
                message.message = msgJson.message
                message.id_member = idMember
                message.id_thread = idThread
                message.Add().then(async (res) => {
                    if (res) {
                        // Envoi d'une notification PUSH lorsqu'un message est ajouté
                        try {
                            let notif = new NotificationPush()
                            let nameSender = `${person.lastname} ${person.firstname}`
                            let thread = await threadMod.GetById(person.nir, idThread)
                            notif.priority = "high"
                            notif.InitMessage(`(${thread.name}) Nouveau message`, `${nameSender} : ${message.message}`)
                            await notif.Send()
                        } catch (e) {
                            console.log(e)
                        }
                        resolve({status: 201, data: "The message has been published."})
                    } else {
                        resolve({status: 400, data: "This message already published."})
                    }
                }).catch((e) => {
                    console.log(e)
                    if (e.code === '23503') resolve({status: 400, data: e.message})
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
        new Message().Get(nir, idThread).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Récupère les membres d'un thread
 * @param nir Le NIR de l'utilisateur
 * @param idThread L'id du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMember = (nir, idThread) => {
    return new Promise((resolve, _) => {
        memberMod.Get(nir, idThread).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Rejoindre un thread
 * @param nir Le NIR de la personne souhaitant rejoindre le thread
 * @param idThread L'id du thread à rejoindre
 * @returns {Promise<unknown>}
 * @constructor
 */
const JoinThread = (nir, idThread) => {
    return new Promise(async (resolve, _) => {
        const idAdherent = await adherentMod.GetAdherentIdByNIR(nir, idThread);
        if (idAdherent === null || idAdherent === -1) {
            resolve({status: 400, data: "You are not in this political party."})
        } else {
            memberMod.Add(idAdherent, idThread).then((res) => {
                if (res) {
                    resolve({status: 201, data: "You have joined the thread."})
                } else {
                    resolve({status: 400, data: "You have already joined this thread."})
                }
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Quitte un thread
 * @param nir Le NIR de la personne souhaitent quitter le thread
 * @param idThread L'id du thread à quitter
 * @returns {Promise<unknown>}
 * @constructor
 */
const LeftThread = (nir, idThread) => {
    return new Promise(async (resolve, _) => {
        const idAdherent = await adherentMod.GetAdherentIdByNIR(nir, idThread);
        if (idAdherent === null) {
            resolve({status: 400, data: "You are not in this political party."})
        } else {
            memberMod.Left(idAdherent, idThread).then((res) => {
                if (res) {
                    resolve({status: 200, data: "You have left this thread."})
                } else {
                    resolve({status: 400, data: "You have already left this thread."})
                }
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Muite/unmute un thread
 * @param nir Le NIR de la personne souhaitent mute/unmute le thread
 * @param idThread L'id du thread à mute/unmute
 * @param mute Mute ou unmute le thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const MuteThread = (nir, idThread, mute = false) => {
    return new Promise(async (resolve, _) => {
        const idMember = await memberMod.GetMemberIdByNIR(nir, idThread);
        if (idMember === null) {
            resolve({status: 400, data: "You are not in this thread."})
        } else {
            memberMod.MuteThread(idMember, mute).then((res) => {
                const word = (mute) ? "mute" : "unmute"
                resolve({status: 200, data: `You have ${word} this thread.`})
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

export default {
    AddThread,
    UpdateThread,
    DeleteThread,
    ChangeMainThread,
    GetThread,
    AddMessage,
    GetMessage,
    GetMember,
    JoinThread,
    LeftThread,
    MuteThread
}
