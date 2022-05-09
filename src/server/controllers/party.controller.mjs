import axios from "axios";
import partyMod from "../models/political-party.mjs"
import adherentMod from "../models/adherent.mjs";
import documentMod from "../models/document.mjs";
import feeMod from "../models/annual-fee.mjs";

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
            if (res.data) {
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
            if (error.response.status === 404) {
                resolve(null)
            } else {
                if (error.code === '23503') resolve({status: 400, data: error.message})
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
                if (!resultParty) {
                    resolve({status: 404, data: "This political party does not exists."})
                } else {
                    partyMod.Add(resultParty).then((res) => {
                        if (res) {
                            resolve({status: 201, data: "Political party has been created."})
                        } else {
                            resolve({status: 400, data: "This political party already existed."})
                        }
                    }).catch((e) => {
                        if (e.code === '23503') resolve({status: 400, data: e.message})
                        resolve({status: 500, data: e})
                    })
                }
            })
        }
    });
}

/**
 * Récupère tous les partis politiques
 * @param siren Le SIREN du parti politique
 * @param nir Le NIR de la personne
 * @param includeLeft Inclure les partis où on est plus
 * @param idPoliticalParty L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetPoliticalParty = (siren = null, nir = null, includeLeft = false, idPoliticalParty = null) => {
    return new Promise((resolve, _) => {
        partyMod.Get(nir, includeLeft, siren, idPoliticalParty).then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            if (e.code === '23503') resolve({status: 400, data: e.message})
            resolve({status: 500, data: e})
        })
    })
}

/**
 * Adhère à un parti politique
 * @param nir Le NIR de la personne qui adhère à un parti
 * @param id_political_party L'id du parti politique auxquels on adhère
 * @returns {Promise<unknown>}
 * @constructor
 */
const JoinParty = (nir, id_political_party) => {
    return new Promise((resolve, _) => {
        if (!nir || !id_political_party) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            adherentMod.Add(nir, id_political_party).then((res) => {
                if (res) {
                    resolve({status: 201, data: "You join this political party."})
                } else {
                    resolve({status: 400, data: "You already join on political party."})
                }
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    })
}

/**
 * Partir d'un parti politique
 * @param nir Le NIR de la personne qui part d'un parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const LeftParty = (nir) => {
    return new Promise((resolve, _) => {
        if (!nir) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            adherentMod.Left(nir).then((res) => {
                if (res) {
                    resolve({status: 201, data: "You left the political party."})
                } else {
                    resolve({status: 400, data: "You already left political party."})
                }
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    })
}

/**
 * Ajoute une nouvelle cotisation annuelle
 * @param annual_fee La cotisation annuelle
 * @returns {Promise<unknown>}
 * @constructor
 */
const AddAnnualFee = (annual_fee) => {
    return new Promise(async (resolve, _) => {
        if (!annual_fee) {
            resolve({status: 400, data: "Missing parameters."})
        } else if (!annual_fee.fee || !annual_fee.id_political_party | !annual_fee.year) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            feeMod.Add(annual_fee).then((res) => {
                if (res) {
                    resolve({status: 201, data: "The annual fee has been created."})
                } else {
                    resolve({status: 400, data: "An annual fee already existed fo this year."})
                }
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Récupères les cotisations annuelles pour un parti politiques
 * @param id_political_party L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAnnualFeeByParty = (id_political_party) => {
    return new Promise((resolve, _) => {
        if (!id_political_party) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            feeMod.Get(null, id_political_party).then((res) => {
                const code = (res) ? 200 : 204;
                resolve({status: code, data: res})
            }).catch((e) => {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            })
        }
    })
}

/**
 * Modifie le logo du parti politique
 * @param logo Le logo du parti politique
 * @param idPoliticalParty L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const UploadLogo = (logo, idPoliticalParty) => {
    return new Promise(async (resolve, _) => {
        if (!logo) {
            resolve({status: 400, data: "Missing file."})
        } else {
            try {
                const doc_id = await documentMod.Add(logo);
                const result = await partyMod.UpdateLogo(doc_id, idPoliticalParty)
                if (result) {
                    resolve({status: 201, data: "The logo has been updated."})
                } else {
                    resolve({status: 404, data: "This political party doesn't existed."})
                }
            } catch (e) {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            }
        }
    })
}

/**
 * Modifie la charte du parti politique
 * @param chart La charte du parti politique
 * @param idPoliticalParty L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const UploadChart = (chart, idPoliticalParty) => {
    return new Promise(async (resolve, _) => {
        if (!chart) {
            resolve({status: 400, data: "Missing file \"logo\"."})
        } else {
            try {
                const doc_id = await documentMod.Add(chart);
                const result = await partyMod.UpdateChart(doc_id, idPoliticalParty)
                if (result) {
                    resolve({status: 201, data: "The chart has been updated."})
                } else {
                    resolve({status: 404, data: "This political party doesn't existed."})
                }
            } catch (e) {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            }
        }
    })
}

/**
 * Modifie les details bancaires du parti politique
 * @param bankDetails Les details bancaires du parti politique
 * @param idPoliticalParty L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const UploadBankDetails = (bankDetails, idPoliticalParty) => {
    return new Promise(async (resolve, _) => {
        if (!bankDetails) {
            resolve({status: 400, data: "Missing file \"bank_details\"."})
        } else {
            try {
                const doc_id = await documentMod.Add(bankDetails);
                const result = await partyMod.UpdateBankDetails(doc_id, idPoliticalParty)
                if (result) {
                    resolve({status: 201, data: "The bank details has been updated."})
                } else {
                    resolve({status: 404, data: "This political party doesn't existed."})
                }
            } catch (e) {
                if (e.code === '23503') resolve({status: 400, data: e.message})
                resolve({status: 500, data: e})
            }
        }
    })
}

export default {
    AddParty,
    GetPoliticalParty,
    JoinParty,
    LeftParty,
    AddAnnualFee,
    GetAnnualFeeByParty,
    UploadLogo,
    UploadChart,
    UploadBankDetails
}
