import {GetResults, Vote} from "../models/vote.mjs";
import {Round} from "../models/round.mjs";
import linkMod from "../models/link-person-round.mjs";
import {Choice} from "../models/choice.mjs";
import {Town} from "../models/town.mjs";
import {Region} from "../models/region.mjs";
import {Department} from "../models/department.mjs";
import {TypeVote} from "../models/type-vote.mjs";
import {Election} from "../models/election.mjs";
import {ResponseApi} from "../models/response-api.mjs";
import {Color} from "../models/color.mjs";

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
                    if (e.code === '23503') {
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
            let colors = await new Color().Get()
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
                    let stats = await GetResults(res[i].id, 2);
                    if(stats.length <= 0) {
                        stats = await GetResults(res[i].id, 1);
                    }
                    if(stats.length > 0) {
                        stats[0].color = colors.find(clr => clr.id === stats[0].id_color)
                        res[i].choice_win = stats[0]
                    }
                    resolveVote()
                }));
            }
            await Promise.all(tabPromise)
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
        })
    });
}


/**
 * Récupère la liste des votes selon les filtres
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetVoteInProgress = (nir) => {
    return new Promise((resolve, _) => {
        new Vote().GetInProgress(nir).then(async (res) => {
            let tabPromise = []
            for (let i = 0; i < res.length; i++) {
                tabPromise.push(new Promise(async (resolveVote, _) => {
                    res[i].rounds = await new Round().Get(nir, res[i].id)
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
            }
            await Promise.all(tabPromise)
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
        })
    });
}

/**
 * Récupère le détail d'un vote
 * @param nir Le NIR de l'utilisateur
 * @param id L'ID du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetVoteDetails = (nir, id) => {
    return new Promise((resolve, _) => {
        new Vote().GetById(id).then(async (res) => {
            if (res != null) {
                let colors = await new Color().Get()
                if (res.town_code_insee) {
                    res.town = await new Town().GetById(res.town_code_insee)
                }
                if (res.reg_code_insee) {
                    res.region = await new Region().GetById(res.reg_code_insee)
                }
                if (res.department_code) {
                    res.department = await new Department().GetById(res.department_code)
                }
                res.rounds = await new Round().Get(nir, res.id)
                res.choices = await new Choice().Get(nir, null, res.id)
                for(let i = 0; i < res.rounds.length; i++){
                    res.rounds[i].choices = await new Choice().Get(nir, res.rounds[i].num, res.id)
                    for(let j = 0; j < res.rounds[i].choices.length; j++) {
                        res.rounds[i].choices[j].color = colors.find(clr => clr.id === res.rounds[i].choices[j].id_color)
                    }
                }
                for(let j = 0; j < res.choices.length; j++) {
                    res.choices[j].color = colors.find(clr => clr.id === res.choices[j].id_color)
                }
            }
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if (e.code === '23503') {
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
                if (e.code === '23503') {
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
            if (e.code === '23503') {
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
        new Round().Get(nir, idVote).then(async (res) => {
            let colors = await new Color().Get()
            for (let i = 0; i < res.length; i++) {
                res[i].choices = new Choice().Get(nir, res[i].num_round, idVote)
                for(let j = 0; j < res[i].choices.length; j++) {
                    res[i].choices[j].color = colors.find(clr => clr.id === res.choices[j].id_color)
                }
            }
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if (e.code === '23503') {
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
                if (e.code === '23503') {
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
        new Choice().Get(nir, numRound, idVote).then(async (res) => {
            let colors = await new Color().Get()
            for(let j = 0; j < res.length; j++) {
                res[j].color = colors.find(clr => clr.id === res[j].id_color)
            }
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if (e.code === '23503') {
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
        } else if (!choiceJson.name || !idVote) {
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
                if (e.code === '23503') {
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
 * @param idChoiceJson
 * @returns {Promise<unknown>}
 * @constructor
 */
const ToVote = (nir, numRound, idVote, idChoiceJson) => {
    return new Promise(async (resolve, _) => {
        if (!idChoiceJson || !numRound || !idVote || !idChoiceJson.id_choice) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            const isExisted = await linkMod.IfExists(idVote, numRound, nir)
            if (isExisted) {
                resolve(new ResponseApi().InitBadRequest("You have already voted for this round."))
                return
            }
            let choice = new Choice()
            choice.id_vote = idVote
            choice.id = idChoiceJson.id_choice
            choice.AddVoter(nir, numRound).then((res) => {
                resolve(new ResponseApi().InitCreated("Your vote has been take into account."))
            }).catch((e) => {
                if (e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

/**
 * Supprime un choix de vote
 * @param id L'id du choix à supprimer
 * @returns {Promise<unknown>}
 * @constructor
 */
const DeleteChoice = (id) => {
    return new Promise((resolve, _) => {
        let choice = new Choice()
        choice.id = id
        choice.Delete().then((res) => {
            if (res) {
                resolve(new ResponseApi().InitCreated("Choice has been created."))
            } else {
                resolve(new ResponseApi().InitBadRequest("This choice does not existed or the election has started."))
            }
        }).catch((e) => {
            resolve(new ResponseApi().InitInternalServer(e))
        })
    });
}

/**
 * Récupère les résultats d'un vote selon un tour de vote
 * @returns {Promise<unknown>}
 * @constructor
 * @param nir
 * @param idVote
 * @param numRound
 */
const GetVoteResults = (nir, idVote, numRound) => {
    return new Promise(async (resolve, _) => {
        try {
            let stats = await GetResults(idVote, numRound);
            let colors = await new Color().Get()
            for(let i = 0; i < stats.length; i++) {
                stats[i].color = colors.find(clr => clr.id === stats[i].id_color)
            }
            resolve(new ResponseApi().InitData(stats))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

export default {
    EnumTypeVote,
    AddVote,
    GetVote,
    GetRound,
    AddRound,
    GetChoice,
    AddChoice,
    ToVote,
    GetElection,
    AddElection,
    GetVoteDetails,
    DeleteChoice,
    GetVoteInProgress,
    GetVoteResults
}
