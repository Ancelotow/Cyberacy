import partyMod from "../models/political-party.mjs"
import groupBy from 'lodash/groupBy.js';

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
            resolve({status: 400, data: "Missing parameters."})
            return;
        }
        try {
            let stats = await partyMod.GetNbAdherent(nir, year);
            if (stats == null) {
                resolve({status: 204, data: "You haven't join any political party."})
                return;
            }
            const statsParty = groupBy(stats, function(n) {
                return n.party_name;
            });
            resolve({status: 200, data: statsParty})
        } catch (e) {
            console.error(e)
            resolve({status: 500, data: e})
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
        let total;
        let statsYears = {};
        let keys;
        for(year; year <= new Date().getFullYear(); year++){
            result = await GetNbAdherentByMonth(nir, year)
            if(result.status !== 200){
                resolve(result);
                return;
            }
            keys = Object.keys(result.data);
            total = 0;
            for(let j = 0; j <  keys.length; j++) {
                for(let i = 0; i < result.data[keys[j]].length; i++){
                    total += result.data[keys[j]][i].nb_adherent;
                }
                if(statsYears[keys[j]] == null) {
                    statsYears[keys[j]] = []
                }
                statsYears[keys[j]].push({year, nb_adherent: total});
            }
        }
        resolve({status: 200, data: statsYears})
    });
}

/**
 * Statistiques : récupère le nombre de meetings par mois
 * @param nir Le NIR de l'utilisateur
 * @param year L'année du filtre (l'année courante par défaut)
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbMeetingByMonth = (nir, year = new Date().getFullYear()) => {
    return new Promise(async (resolve, _) => {
        if (!nir) {
            resolve({status: 400, data: "Missing parameters."})
            return;
        }
        try {
            let stats = await partyMod.GetNbMeeting(nir, year);
            if (stats == null) {
                resolve({status: 204, data: "You haven't join any political party."})
                return;
            }
            const statsParty = groupBy(stats, function(n) {
                return n.party_name;
            });
            resolve({status: 200, data: statsParty})
        } catch (e) {
            console.error(e)
            resolve({status: 500, data: e})
        }
    });
}

/**
 * Statistiques : récupère le nombre de meeting par an
 * @param nir Le NIR de l'utilisateur
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbMeetingByYear = (nir) => {
    return new Promise(async (resolve, _) => {
        let year = new Date().getFullYear() - 10;
        let result;
        let total_meeting;
        let total_participant;
        let statsYears = {};
        let keys;
        for(year; year <= new Date().getFullYear(); year++){
            result = await GetNbMeetingByMonth(nir, year)
            if(result.status !== 200){
                resolve(result);
                return;
            }
            keys = Object.keys(result.data);
            total_meeting = 0;
            total_participant = 0;
            for(let j = 0; j <  keys.length; j++) {
                for(let i = 0; i < result.data[keys[j]].length; i++){
                    total_meeting += result.data[keys[j]][i].nb_meeting;
                    total_participant += result.data[keys[j]][i].nb_participant;
                }
                if(statsYears[keys[j]] == null) {
                    statsYears[keys[j]] = []
                }
                statsYears[keys[j]].push({year, nb_meeting: total_meeting, nb_participant: total_participant});
            }
        }
        resolve({status: 200, data: statsYears})
    });
}

export default {GetNbAdherentByMonth, GetNbAdherentByYear, GetNbMeetingByMonth, GetNbMeetingByYear}
