import {Vote} from "../models/vote.mjs";
import {Round} from "../models/round.mjs";
import linkMod from "../models/link-person-round.mjs";
import {Choice} from "../models/choice.mjs";
import {Town} from "../models/town.mjs";
import {Region} from "../models/region.mjs";
import {Department} from "../models/department.mjs";
import {TypeVote} from "../models/type-vote.mjs";
import {Election} from "../models/election.mjs";
import {ResponseApi} from "../models/response-api.mjs";

const EnumTypeVote = Object.freeze({
    Presidential: 1,
    Regional: 2,
    Departmental: 3,
    Municipal: 4,
    Legislative: 5,
    Referendum: 6,
    PrivateSurvey: 7,
    PublicSurvey: 8,
})

/**
 * Vérifie si le type de vote est cohérent avec les données du vote
 * @param vote Le vote à vérifier
 * @returns {boolean}
 * @constructor
 */
function CheckTypeVote(vote) {
    switch (vote.id_type_vote) {
        case EnumTypeVote.Presidential:
        case EnumTypeVote.Legislative:
        case EnumTypeVote.Referendum:
        case EnumTypeVote.PublicSurvey:
            return true

        case EnumTypeVote.Regional:
            return vote.reg_code_insee != null

        case EnumTypeVote.Departmental:
            return vote.department_code != null

        case EnumTypeVote.Municipal:
            return vote.town_code_insee != null

        case EnumTypeVote.PrivateSurvey:
            return vote.id_political_party != null

        default:
            return false
    }
}

/**
 * Ajoute un nouveau vote
 * @returns {Promise<unknown>}
 * @constructor
 * @param voteJson
 * @param id_election
 */
const AddVote = (voteJson, id_election) => {
    return new Promise((resolve, _) => {
        if (!voteJson) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!voteJson.name || id_election || !voteJson.nb_voter) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            if (!CheckTypeVote(voteJson)) {
                resolve(new ResponseApi().InitBadRequest("Missing parameters about the type of vote selected."))
            } else {
                let vote = new Vote()
                Object.assign(vote, voteJson)
                vote.id_election = id_election
                vote.Add().then((res) => {
                    if (res) {
                        resolve(new ResponseApi().InitCreated("Vote has been created."))
                    } else {
                        resolve(new ResponseApi().InitBadRequest("This vote already existed."))
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
 * Récupère la liste des votes selon les filtres
 * @param nir Le NIR de l'utilisateur
 * @param idElection
 * @param includeFinish Inclus les votes passés
 * @param includeFuture Inclus les votes futur
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetVote = (nir, idElection, includeFinish = false, includeFuture = true) => {
    return new Promise((resolve, _) => {
        new Vote().Get(nir, idElection, includeFinish, includeFuture).then(async (res) => {
            let tabPromise = []
            for (let i = 0; i < res.length; i++) {
                tabPromise.push(new Promise(async (resolveVote, _) => {
                    if (res[i].town_code_insee) {
                        res[i].town = await new Town().GetById(res[i].town_code_insee)
                    }
                    if (res[i].reg_code_insee) {
                        res[i].region = await new Region().GetById(res[i].reg_code_insee)
                    }
                    if (res[i].department_code) {
                        res[i].department = await new Department().GetById(res[i].department_code)
                    }
                    resolveVote()
                }));
                //res[i].rounds = await new Round().Get(nir, res[i].id)
            }
            await Promise.all(tabPromise)
            console.log("finish vote")
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
 * Ajoute une nouvelle élection
 * @param electionJson L'élection en JSON
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddElection = (electionJson) => {
    return new Promise((resolve, _) => {
        if (!electionJson) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!electionJson.name || !electionJson.id_type_vote || !electionJson.date_start || !electionJson.date_end) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let election = new Election()
            Object.assign(election, electionJson)
            election.date_start = new Date(election.date_start)
            election.date_end = new Date(election.date_end)
            election.Add().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Vote has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This vote already existed."))
                }
            }).catch((e) => {
                console.error(e)
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
 * Récupère la liste des élections
 * @param nir Le NIR de l'utilisateur
 * @param idElection L'id de l'élection
 * @param includeFinish Inclure les élections finies
 * @param includeFuture Inclure les élections futures
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetElection = (nir, idElection = null, includeFinish = false, includeFuture = true) => {
    return new Promise((resolve, _) => {
        new Election().Get(nir, idElection, includeFinish, includeFuture).then(async (res) => {
            for (let i = 0; i < res.length; i++) {
                let listTypes = await new TypeVote().Get()
                res[i].type_vote = listTypes.filter(e => e.id === res[i].id_type_vote)[0]
                //res[i].votes = await new Vote().Get(nir, res[i].id, true, true)
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
 * Récupère la liste des tours de votes selon les filtres
 * @param nir Le NIR de l'utilisateur
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetRound = (nir, idVote) => {
    return new Promise((resolve, _) => {
        if (!idVote) {
            resolve(new ResponseApi().InitMissingParameters())
            return
        }
        new Round().Get(nir, idVote).then((res) => {
            for (let i = 0; i < res.length; i++) {
                res[i].choices = new Choice().Get(nir, res[i].num_round, idVote)
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
 * Ajoute un nouveau tour de vote
 * @param roundJson
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddRound = (roundJson, idVote) => {
    return new Promise((resolve, _) => {
        if (!roundJson) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!roundJson.num || !idVote || !roundJson.name) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!roundJson.date_start || !roundJson.date_end) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let round = new Round()
            Object.assign(round, roundJson)
            round.id_vote = idVote
            round.date_start = new Date(round.date_start)
            round.date_end = new Date(round.date_end)
            round.Add().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Round has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This round already existed."))
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
 * Récupère la liste des choix sur un tour de vote donné
 * @param nir Le NIR de l'utilisateur
 * @param numRound Le numéro du tour de vote
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetChoice = (nir, numRound, idVote) => {
    return new Promise((resolve, _) => {
        new Choice().Get(nir, numRound, idVote).then((res) => {
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
 * Ajoute un nouveau choix sur un tour de vote
 * @param choiceJson
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddChoice = (choiceJson, idVote) => {
    return new Promise((resolve, _) => {
        if (!choiceJson) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!choiceJson.name || !choiceJson.choice_order || !idVote) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            let choice = new Choice()
            Object.assign(choice, choiceJson)
            choice.id_vote = idVote
            choice.Add().then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Choice has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This choice already existed."))
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
 * Permet à un utilisateur de voter
 * @param nir Le NIR du votant
 * @param numRound Le numéro du tour de vote
 * @param idVote L'id du vote
 * @param idChoice L'id du chois
 * @returns {Promise<unknown>}
 * @constructor
 */
const ToVote = (nir, numRound, idVote, idChoice) => {
    return new Promise(async (resolve, _) => {
        if (!idChoice || !numRound || !idVote) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            const isExisted = await linkMod.IfExists(idVote, numRound, nir)
            if (isExisted) {
                resolve(new ResponseApi().InitBadRequest("You have already voted for this round."))
                return
            }
            let choice = new Choice()
            choice.id_vote = idVote
            choice.id = idChoice
            choice.AddVoter(nir, numRound).then((res) => {
                resolve(new ResponseApi().InitCreated("Your vote has been take into account."))
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

export default {EnumTypeVote, AddVote, GetVote, GetRound, AddRound, GetChoice, AddChoice, ToVote, GetElection, AddElection}
