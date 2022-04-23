import axios from "axios";
import partyMod from "../models/political-party.mjs"

const uri_api_siren = "https://entreprise.data.gouv.fr/api/sirene/v3/unites_legales/"

/**
 * Récupère le parti politique depuis l'API du gouvernement
 * @param siren Le SIREN du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
function GetPartyFromGov(siren) {
    return new Promise((resolve, _) => {
        axios.get(uri_api_siren + siren).then(async (res) => {
            if(res.data){
                let party = new partyMod.PoliticalParty()
                party.siren = res.data.unite_legale.siren
                party.name = res.data.unite_legale.denomination
                party.date_create = new Date(res.data.unite_legale.date_creation)
                party.address_street = res.data.unite_legale.etablissement_siege.geo_l4
                party.town_code_insee = res.data.unite_legale.etablissement_siege.code_commune
                resolve(party)
            } else {
                resolve(null)
            }
        });
    });
}
