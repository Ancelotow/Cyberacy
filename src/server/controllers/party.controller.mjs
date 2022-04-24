import axios from "axios";
import partyMod from "../models/political-party.mjs"

const uri_api_siren = "https://entreprise.data.gouv.fr/api/sirene/v3/unites_legales/"

/**
 * Récupère le parti politique depuis l'API du gouvernement
 * @param party Le parti politique à rechercher
 * @returns {Promise<unknown>}
 * @constructor
 */
function GetAssociationFromGov(party) {
    return new Promise((resolve, reject) => {
        axios.get(uri_api_siren + party.siren).then(async (res) => {
            if(res.data){
                party.siren = res.data.unite_legale.siren
                party.name = res.data.unite_legale.denomination
                party.date_create = new Date(res.data.unite_legale.date_creation)
                party.address_street = res.data.unite_legale.etablissement_siege.geo_l4
                party.town_code_insee = res.data.unite_legale.etablissement_siege.code_commune
                resolve(party)
            } else {
                resolve(null)
            }
        }).catch((error) => {
            if(error.response.status === 404){
                resolve(null)
            } else {
                reject(error)
            }
        });
    });
}

/**
 * Ajoute un nouveau parti politique
 * @param party Le nouveau parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddParty = (party) => {
    return new Promise(async (resolve, _) => {
        if (!party) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!party.siren || !party.url_logo | !party.object) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!party.id_political_edge || !party.nir) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            GetAssociationFromGov(party).then((resultParty) => {
                if(!resultParty) {
                    resolve({status: 404, data: "This political party does not exists."})
                } else {
                    partyMod.Add(resultParty).then((res) => {
                        if (res) {
                            resolve({status: 201, data: "Political party has been created."})
                        } else {
                            resolve({status: 400, data: "This political party already existed."})
                        }
                    }).catch((e) => {
                        console.error(e)
                        resolve({status: 500, data: e})
                    })
                }
            })
        }
    });
}

export default {AddParty}
