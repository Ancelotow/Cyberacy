import partyMod from "../models/political-party.mjs"
import groupBy from 'lodash/groupBy.js';


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

export default {GetNbAdherentByMonth}
