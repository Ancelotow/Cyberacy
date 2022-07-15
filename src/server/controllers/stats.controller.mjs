import partyMod from "../models/political-party.mjs"
import {GetStatsAbsentions, GetStatsParticipations, GetResults} from "../models/vote.mjs"
import groupBy from 'lodash/groupBy.js'
import {ResponseApi} from "../models/response-api.mjs";

/**
 * Statistiques : récupère le nombre d'adhérent par mois
 * @param nir Le NIR de l'utilisateur
 * @param year L'année du filtre (l'année courante par défaut)
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbAdherentByMonth = (nir, year = new Date().getFullYear()) => {
    return new Promise(async (resolve, _) => {
        if (!nir) {
            resolve(new ResponseApi().InitMissingParameters())
            return;
        }
        try {
            let stats = await partyMod.GetNbAdherent(nir, year);
            let allPartys = await partyMod.GetAllPartyForStats()
            if (stats == null) {
                resolve(new ResponseApi().InitNoContent())
                return;
            }
            let listStats = []
            for(let i = 0; i < allPartys.length; i++) {
                allPartys[i].year = parseInt(year)
                allPartys[i].stats = stats.filter(s => s.id_political_party === allPartys[i].id)
                if(allPartys[i].stats.length > 0) {
                    listStats.push(allPartys[i])
                }
            }
            resolve(new ResponseApi().InitData(listStats))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

/**
 * Statistiques : récupère le nombre d'adhérent par an
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbAdherentByYear = (nir) => {
    return new Promise(async (resolve, _) => {
        let year = new Date().getFullYear() - 10;
        let result;
        let allPartys = await partyMod.GetAllPartyForStats()
        for(let i = 0; i < allPartys.length; i++) {
            allPartys[i].stats = []
        }
        for (year; year <= new Date().getFullYear(); year++) {
            result = await partyMod.GetNbAdherent(nir, year)
            for(let i = 0; i < allPartys.length; i++) {
                let resultMonth  = result.filter(s => s.id_political_party === allPartys[i].id)
                if(resultMonth.length > 0) {
                    let total = 0
                    for(let j = 0; j < resultMonth.length; j++) {
                        total += resultMonth[j].nb_adherent
                    }
                    allPartys[i].stats.push({year, total})
                }
            }
        }
        let statsYear = allPartys.filter(party => party.stats.length > 0)
        resolve(new ResponseApi().InitData(statsYear))
    });
}

/**
 * Statistiques : récupère le nombre de meetings par mois
 * @param nir Le NIR de l'utilisateur
 * @param year L'année du filtre (l'année courante par défaut)
 * @param idPoliticalParty
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbMeetingByMonth = (nir, year = new Date().getFullYear(), idPoliticalParty = null) => {
    return new Promise(async (resolve, _) => {
        if (!nir) {
            resolve(new ResponseApi().InitMissingParameters())
            return;
        }
        try {
            let stats = await partyMod.GetNbMeeting(nir, year, idPoliticalParty);
            let allPartys = await partyMod.GetAllPartyForStats()
            if (stats == null) {
                resolve(new ResponseApi().InitNoContent())
                return;
            }
            let listStats = []
            for(let i = 0; i < allPartys.length; i++) {
                allPartys[i].year = parseInt(year)
                allPartys[i].stats = stats.filter(s => s.id_political_party === allPartys[i].id)
                if(allPartys[i].stats.length > 0) {
                    listStats.push(allPartys[i])
                }
            }
            resolve(new ResponseApi().InitData(listStats))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

/**
 * Statistiques : récupère le nombre de meeting par an
 * @param nir Le NIR de l'utilisateur
 * @param idPoliticalParty
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbMeetingByYear = (nir, idPoliticalParty = null) => {
    return new Promise(async (resolve, _) => {
        let year = new Date().getFullYear() - 10;
        let result;
        let allPartys = await partyMod.GetAllPartyForStats()
        for(let i = 0; i < allPartys.length; i++) {
            allPartys[i].stats = []
        }
        for (year; year <= new Date().getFullYear(); year++) {
            result = await partyMod.GetNbMeeting(nir, year, idPoliticalParty)
            if(result) {
                for(let i = 0; i < allPartys.length; i++) {
                    let resultMonth  = result.filter(s => s.id_political_party === allPartys[i].id)
                    if(resultMonth.length > 0) {
                        let total_participant = 0
                        let total_meeting = 0
                        for(let j = 0; j < resultMonth.length; j++) {
                            total_participant += resultMonth[j].nb_participant
                            total_meeting += resultMonth[j].nb_meeting
                        }
                        allPartys[i].stats.push({year, total_participant, total_meeting})
                    }
                }
            }
        }
        let statsYear = allPartys.filter(party => party.stats.length > 0)
        resolve(new ResponseApi().InitData(statsYear))
    });
}

/**
 * Statistiques : Récupère les cotisations annuelles par parti politique et le total récolté
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAnnualFee = (nir) => {
    return new Promise(async (resolve, _) => {
        if (!nir) {
            resolve(new ResponseApi().InitMissingParameters())
            return;
        }
        try {
            let stats = await partyMod.GetAnnualFee(nir);
            let allPartys = await partyMod.GetAllPartyForStats()
            if (stats == null) {
                resolve(new ResponseApi().InitNoContent())
                return;
            }
            let listStats = []
            for(let i = 0; i < allPartys.length; i++) {
                allPartys[i].year = parseInt(year)
                allPartys[i].stats = stats.filter(s => s.id_political_party === allPartys[i].id)
                if(allPartys[i].stats.length > 0) {
                    listStats.push(allPartys[i])
                }
            }
            resolve(new ResponseApi().InitData(listStats))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

/**
 * Récupère le nombre de message pour chaque thread sur une date donnée
 * @param nir Le NIR de l'utilisateur
 * @param date La date
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMessagesByDate = (nir, date = new Date()) => {
    return new Promise(async (resolve, _) => {
        if (!nir) {
            resolve(new ResponseApi().InitMissingParameters())
            return;
        }
        try {
            let stats = await partyMod.GetNbMessageByDay(nir, new Date(date));
            if (stats == null) {
                resolve(new ResponseApi().InitNoContent())
                return;
            }
            resolve(new ResponseApi().InitData(TransformResultThread(stats)))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

/**
 * Récupère le nombre de message pour chaque thread sur une date donnée
 * @param nir Le NIR de l'utilisateur
 * @param year L'année de la recherche'
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMessagesByWeeks = (nir, year = new Date().getFullYear()) => {
    return new Promise(async (resolve, _) => {
        if (!nir) {
            resolve(new ResponseApi().InitMissingParameters())
            return;
        }
        try {
            let stats = await partyMod.GetNbMessageByWeeks(nir, year);
            if (stats == null) {
                resolve(new ResponseApi().InitNoContent())
                return;
            }
            resolve(new ResponseApi().InitData(TransformResultThread(stats)))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

/**
 * Récupère les absentions
 * @param num_round
 * @param id_type_vote Tri par type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetVoteAbstention = (num_round = 1, id_type_vote = null) => {
    return new Promise(async (resolve, _) => {
        try {
            let stats = await GetStatsAbsentions(num_round, id_type_vote);
            if (stats == null) {
                resolve(new ResponseApi().InitNoContent())
                return;
            }
            resolve(new ResponseApi().InitData(stats))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

/**
 * Récupère les participations
 * @param num_round
 * @param id_type_vote Tri par type de vote
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetVoteParticipation = (num_round = 1, id_type_vote = null) => {
    return new Promise(async (resolve, _) => {
        try {
            let stats = await GetStatsParticipations(num_round, id_type_vote);
            if (stats == null) {
                resolve(new ResponseApi().InitNoContent())
                return;
            }
            resolve(new ResponseApi().InitData(stats))
        } catch (e) {
            resolve(new ResponseApi().InitInternalServer(e))
        }
    });
}

function TransformResultThread(result) {
    if (!result) {
        return null;
    }
    const statsParty = groupBy(result, function (n) {
        return n.party_name;
    });
    const keys = Object.keys(statsParty);
    let statsFilterThread = [];
    let resultThread;
    for (let i = 0; i < keys.length; i++) {
        resultThread = groupBy(statsParty[keys[i]], function (n) {
            return n.thread_name;
        });
        let keysThread = Object.keys(resultThread);
        let threads = []
        for(let j = 0; j < keysThread.length; j++) {
            let stats = statsParty[keys[i]].filter(e => e.thread_name === keysThread[j])
            threads.push({name: keysThread[j], stats})
        }
        statsFilterThread.push({name: keys[i], threads})
    }
    return statsFilterThread;
}

export default {
    GetNbAdherentByMonth,
    GetNbAdherentByYear,
    GetNbMeetingByMonth,
    GetNbMeetingByYear,
    GetAnnualFee,
    GetMessagesByDate,
    GetMessagesByWeeks,
    GetVoteAbstention,
    GetVoteParticipation
}
