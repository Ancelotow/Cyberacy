import voteMod from "../models/vote.mjs";

const EnumTypeVote = Object.freeze({
    Presidentiel: 1,
    Regional: 2,
    Departemental: 3,
    Municipal: 4,
    Legislative: 5,
    Referendum: 6
})

/**
 * Vérifie si le type de vote est cohérent avec les données du vote
 * @param vote Le vote à vérifier
 * @returns {boolean}
 * @constructor
 */
function CheckTypeVote(vote) {
    switch (vote.id_type_vote){
        case EnumTypeVote.Presidentiel:
        case EnumTypeVote.Legislative:
        case EnumTypeVote.Referendum:
            return true

        case EnumTypeVote.Regional:
            return vote.reg_code_insee != null

        case EnumTypeVote.Departemental:
            return vote.department_code != null

        case EnumTypeVote.Municipal:
            return vote.town_code_insee != null

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
        } else if (!vote.name || !vote.date_start || !vote.date_end) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!vote.num_round || !vote.id_type_vote || !vote.nb_voter) {
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
                    resolve({status: 500, data: e})
                })
            }
        }
    });
}

export default {EnumTypeVote, AddVote}
