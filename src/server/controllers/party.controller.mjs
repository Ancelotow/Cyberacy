import axios from "axios";
import partyMod from "../models/political-party.mjs"
import adherentMod from "../models/adherent.mjs";
import documentMod from "../models/document.mjs";
import feeMod from "../models/annual-fee.mjs";
import {Meeting} from "../models/meeting.mjs";
import {ResponseApi} from "../models/response-api.mjs";

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
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!party.siren || !party.url_logo | !party.object) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!party.id_political_edge || !party.nir) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            GetAssociationFromGov(party).then((resultParty) => {
                if (!resultParty) {
                    resolve(new ResponseApi().InitBadRequest("This political party does not exists."))
                } else {
                    partyMod.Add(resultParty).then((res) => {
                        if (res) {
                            resolve(new ResponseApi().InitCreated("Political party has been created."))
                        } else {
                            resolve(new ResponseApi().InitBadRequest("This political party already existed."))
                        }
                    }).catch((e) => {
                        if(e.code === '23503') {
                            resolve(new ResponseApi().InitBadRequest(e.message))
                            return
                        }
                        resolve(new ResponseApi().InitInternalServer(e))
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
        partyMod.Get(nir, includeLeft, siren, idPoliticalParty).then(async (res) => {
            const code = (res) ? 200 : 204;
            if(code === 200) {
                for(let i = 0; i < res.length; i++) {
                    let listMeeting = await new Meeting().Get(null, res[i].id, null, false, true)
                    if(listMeeting.length > 0) {
                        res[i].next_meeting = listMeeting[0]
                    }
                }
            }
            resolve(new ResponseApi().InitData(res))
        }).catch((e) => {
            if(e.code === '23503') {
                resolve(new ResponseApi().InitBadRequest(e.message))
                return
            }
            resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            adherentMod.Add(nir, id_political_party).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("You join this political party."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("You already join on political party."))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            adherentMod.Left(nir).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("You left the political party."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("You already left political party."))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else if (!annual_fee.fee || !annual_fee.id_political_party | !annual_fee.year) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            feeMod.Add(annual_fee).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("The annual fee has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("An annual fee already existed fo this year."))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            feeMod.Get(null, id_political_party).then((res) => {
                resolve(new ResponseApi().InitData(res))
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            try {
                const doc_id = await documentMod.Add(logo);
                const result = await partyMod.UpdateLogo(doc_id, idPoliticalParty)
                if (result) {
                    resolve(new ResponseApi().InitCreated("The logo has been updated."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This political party doesn't existed."))
                }
            } catch (e) {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            try {
                const doc_id = await documentMod.Add(chart);
                const result = await partyMod.UpdateChart(doc_id, idPoliticalParty)
                if (result) {
                    resolve(new ResponseApi().InitCreated("TThe chart has been updated."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This political party doesn't existed."))
                }
            } catch (e) {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            try {
                const doc_id = await documentMod.Add(bankDetails);
                const result = await partyMod.UpdateBankDetails(doc_id, idPoliticalParty)
                if (result) {
                    resolve(new ResponseApi().InitCreated("The bank details has been updated."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This political party doesn't existed."))
                }
            } catch (e) {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                resolve(new ResponseApi().InitInternalServer(e))
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
