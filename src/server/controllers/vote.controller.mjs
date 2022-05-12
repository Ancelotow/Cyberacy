import voteMod from "../models/vote.mjs";
import roundMod from "../models/round.mjs";

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
    switch (vote.id_type_vote){
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
 * @param vote Le nouveau vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddVote = (vote) => {
    return new Promise((resolve, _) => {
        if (!vote) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!vote.name || !vote.id_type_vote) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            if(!CheckTypeVote(vote)) {
                resolve({status: 400, data: "Missing parameters about the type of vote selected."})
            } else {
                vote.date_start = new Date(vote.date_start)
                vote.date_end = new Date(vote.date_end)
                voteMod.Add(vote).then((res) => {
                    if (res) {
                        resolve({status: 201, data: "Vote has been created."})
                    } else {
                        resolve({status: 400, data: "This vote already existed."})
                    }
                }).catch((e) => {
                    console.error(e)
                    if(e.code === '23503') resolve({status: 400, data: e.message})
                    resolve({status: 500, data: e})
                })
            }
        }
    });
}

/**
 * Récupère la liste des votes selon les filtres
 * @param nir Le NIR de l'utilisateur
 * @param includeFinish Inclus les votes passés
 * @param includeFuture Inclus les votes futur
 * @param idTypeVote L'id du type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetVote = (nir, includeFinish = false, includeFuture = true, idTypeVote = null) => {
    return new Promise((resolve, _) => {
        voteMod.Get(nir, includeFinish, includeFuture, idTypeVote).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            if(e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Récupère la liste des tours de votes selon les filtres
 * @param nir Le NIR de l'utilisateur
 * @param includeFinish Inclus les votes passés
 * @param includeFuture Inclus les votes futur
 * @param idTypeVote L'id du type de vote
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetRound = (nir, includeFinish = false, includeFuture = true, idTypeVote = null, idVote = null) => {
    return new Promise((resolve, _) => {
        roundMod.Get(nir, includeFinish, includeFuture, idTypeVote, idVote).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            if(e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Ajoute un nouveau tour de vote
 * @param round Le nouveau tour de vote
 * @param idVote L'id du vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddRound = (round, idVote) => {
    return new Promise((resolve, _) => {
        if (!round) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!round.num || !idVote || !round.name) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!round.nb_voter || !round.date_start || !round.date_end) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            round.id_vote = idVote
            round.date_start = new Date(round.date_start)
            round.date_end = new Date(round.date_end)
            roundMod.Add(round).then((res) => {
                if (res) {
                    resolve({status: 201, data: "Round has been created."})
                } else {
                    resolve({status: 400, data: "This round already existed."})
                }
            }).catch((e) => {
                if(e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

export default {EnumTypeVote, AddVote, GetVote, GetRound, AddRound}
