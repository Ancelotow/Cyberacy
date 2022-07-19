import {Thread} from "../models/thread.mjs";
import {Message} from "../models/message.mjs";
import memberMod from "../models/member.mjs";
import adherentMod from "../models/adherent.mjs";
import {NotificationPush} from "../models/notification-push.mjs";
import {ResponseApi} from "../models/response-api.mjs";

/**
 * Ajoute un nouveau thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddThread = (thrJson) => {
    return new Promise(async (resolve, _) => {
        if (!thrJson) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!thrJson.name || !thrJson.id_political_party) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let thread = new Thread()
            Object.assign(thread, thrJson)
            thread.Add().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Thread has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This thread already existed."))
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
 * Supprime un thread existant
 * @param id L'id du thread à supprimer
 * @returns {Promise<unknown>}
 * @constructor
 */
const DeleteThread = (id) => {
    return new Promise(async (resolve, _) => {
        if (!id) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let thread = new Thread()
            thread.id = id
            thread.Delete().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This thread not existed."))
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
 * Change le thread principal d'un parti politique
 * @param id L'id du thread
 * @param id_political_party L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const ChangeMainThread = (id, id_political_party) => {
    return new Promise(async (resolve, _) => {
        if (!id || !id_political_party) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            new Thread().ChangeMainThread(id, id_political_party).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This main thread not existed."))
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
 * Modifie un thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateThread = (thrJson) => {
    return new Promise(async (resolve, _) => {
        if (!thrJson || !thrJson.id) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!thrJson.id || !thrJson.name || !thrJson.id_political_party) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let thread = new Thread()
            Object.assign(thread, thrJson)
            thread.Update().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This thread not existed."))
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
 * Récupère les threads selon les filtres et les droits
 * @param nir Le NIR de la personne
 * @param onlyMine Récupérer uniquement les threads où la personne est membre
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetThread = (nir, onlyMine = true) => {
    return new Promise((resolve, _) => {
        new Thread().Get(nir, onlyMine).then(async (res) => {
            const code = (res.length > 0) ? 200 : 204;
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
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if(e.code === '23503') {
                resolve(new ResponseApi().InitBadRequest(e.message))
                return
            }
            resolve(new ResponseApi().InitInternalServer(e))
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
        if (idThread == null || msgJson == null) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (msgJson.message == null) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            const idMember = await memberMod.GetMemberIdByNIR(person.nir, idThread);
            if (idMember === null || idMember === -1) {
                resolve(new ResponseApi().InitBadRequest("You are not in this thread."))
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
                            let thread = await new Thread().GetById(person.nir, idThread)
                            notif.priority = "high"
                            notif.to = `/topics/${thread.fcm_topic}`
                            notif.InitMessage(`(${thread.name}) Nouveau message`, `${nameSender} : ${message.message}`)
                            await notif.Send()
                        } catch (e) {
                            console.error(e)
                        }
                        resolve(new ResponseApi().InitCreated("The message has been published."))
                    } else {
                        resolve(new ResponseApi().InitBadRequest("This message already published."))
                    }
                }).catch((e) => {
                    if(e.code === '23503') {
                        resolve(new ResponseApi().InitBadRequest(e.message))
                        return
                    }
                    resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitBadRequest("You are not in this political party."))
        } else {
            memberMod.Add(idAdherent, idThread).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("You have joined the thread."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("You have already joined this thread."))
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
            resolve(new ResponseApi().InitBadRequest("You are not in this political party."))
        } else {
            memberMod.Left(idAdherent, idThread).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitOK(null))
                } else {
                    resolve(new ResponseApi().InitBadRequest("You have already left this thread."))
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
            resolve(new ResponseApi().InitBadRequest( "You are not in this thread."))
        } else {
            memberMod.MuteThread(idMember, mute).then((res) => {
                resolve(new ResponseApi().InitOK(null))
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
