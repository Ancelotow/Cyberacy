import {Vote} from "../models/vote.mjs";
import {Round} from "../models/round.mjs";
import linkMod from "../models/link-person-round.mjs";
import {Choice} from "../models/choice.mjs";
import {Town} from "../models/town.mjs";
import {Region} from "../models/region.mjs";
import {Department} from "../models/department.mjs";
import {TypeVote} from "../models/type-vote.mjs";
import {Election} from "../models/election.mjs";

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
            resolve({status: 400, data: "Missing parameters."})
        } else if (!voteJson.name || id_election || !voteJson.nb_voter) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            if (!CheckTypeVote(voteJson)) {
                resolve({status: 400, data: "Missing parameters about the type of vote selected."})
            } else {
                let vote = new Vote()
                Object.assign(vote, voteJson)
                vote.id_election = id_election
                vote.Add().then((res) => {
                    if (res) {
                        resolve({status: 201, data: "Vote has been created."})
                    } else {
                        resolve({status: 400, data: "This vote already existed."})
                    }
                }).catch((e) => {
                    console.error(e)
                    if (e.code === '23503') resolve({status: 400, data: e.message})
                    resolve({status: 500, data: e})
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
            const code = (res.length > 0) ? 200 : 204;
            for (let i = 0; i < res.length; i++) {
                if (res[i].town_code_insee) {
                    res[i].town = await new Town().GetById(res[i].town_code_insee)
                }
                if (res[i].reg_code_insee) {
                    res[i].region = await new Region().GetById(res[i].reg_code_insee)
                }
                if (res[i].department_code) {
                    res[i].department = await new Department().GetById(res[i].department_code)
                }
                res[i].rounds = await new Round().Get(nir, res[i].id)
            }
            resolve({status: code, data: res})
        }).catch((e) => {
            if (e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else if (!electionJson.name || !electionJson.id_type_vote || !electionJson.date_start || !electionJson.date_end) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            let election = new Election()
            Object.assign(election, electionJson)
            election.date_start = new Date(election.date_start)
            election.date_end = new Date(election.date_end)
            election.Add().then((res) => {
                if (res) {
                    resolve({status: 201, data: "Vote has been created."})
                } else {
                    resolve({status: 400, data: "This vote already existed."})
                }
            }).catch((e) => {
                console.error(e)
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
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
            const code = (res.length > 0) ? 200 : 204;
            for (let i = 0; i < res.length; i++) {
                let listTypes = await new TypeVote().Get()
                res[i].type_vote = listTypes.filter(e => e.id === res[i].id_type_vote)[0]
                res[i].votes = await new Vote().Get(nir, res[i].id, true, true)
            }
            resolve({status: code, data: res})
        }).catch((e) => {
            if (e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
            return
        }
        new Round().Get(nir, idVote).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            if (e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else if (!roundJson.num || !idVote || !roundJson.name) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!roundJson.date_start || !roundJson.date_end) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            let round = new Round()
            Object.assign(round, roundJson)
            round.id_vote = idVote
            round.date_start = new Date(round.date_start)
            round.date_end = new Date(round.date_end)
            round.Add().then((res) => {
                if (res) {
                    resolve({status: 201, data: "Round has been created."})
                } else {
                    resolve({status: 400, data: "This round already existed."})
                }
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
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
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            if (e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Ajoute un nouveau choix sur un tour de vote
 * @param choiceJson
 * @param numRound Le numéro du tour de vote
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddChoice = (choiceJson, idVote, numRound) => {
    return new Promise((resolve, _) => {
        if (!choiceJson) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!choiceJson.name || !choiceJson.choice_order) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!numRound || !idVote) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            let choice = new Choice()
            Object.assign(choice, choiceJson)
            choice.id_vote = idVote
            choice.num_round = numRound
            choice.Add().then((res) => {
                if (res) {
                    resolve({status: 201, data: "Choice has been created."})
                } else {
                    resolve({status: 400, data: "This choice already existed."})
                }
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
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
            resolve({status: 400, data: "Missing parameters."})
        } else {
            const isExisted = await linkMod.IfExists(idVote, numRound, nir)
            if (isExisted) {
                return resolve({status: 400, data: "You have already voted for this round."})
            }
            let choice = new Choice()
            choice.id_vote = idVote
            choice.num_round = numRound
            choice.id = idChoice
            choice.AddVoter(nir).then((res) => {
                resolve({status: 201, data: "Your vote has been take into account."})
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

export default {EnumTypeVote, AddVote, GetVote, GetRound, AddRound, GetChoice, AddChoice, ToVote, GetElection, AddElection}
