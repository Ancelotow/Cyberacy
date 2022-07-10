import {pool} from "../middlewares/postgres.mjs";
import {FormaterDate} from "../middlewares/formatter.mjs";

class PoliticalParty {
    id
    name
    url_logo
    date_create
    description
    is_delete
    date_delete
    object
    address_street
    siren
    chart
    iban
    url_bank_details
    url_chart
    id_political_edge
    nir
    town_code_insee
    doc_logo
    doc_bank_details
    doc_chart
    next_meeting = null
}

class StatsAdherent {
    id_political_party
    party_name
    month
    year
    nb_adherent
}

class StatsMeeting {
    id_political_party
    party_name
    month
    year
    nb_meeting
    nb_participant
}

class StatsAnnualFee {
    id_political_party
    party_name
    year
    total_fee
    annual_fee
}

class StatsMessageHour {
    id_political_party
    party_name
    thread_name
    id_thread
    nb_message
    hour
}

class StatsMessageWeek {
    id_political_party
    party_name
    thread_name
    id_thread
    nb_message
    week
}

/**
 * Ajoute un nouveau parti politique
 * @param party
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (party) => {
    return new Promise(async (resolve, reject) => {
        const isExisted = await IfExistsBySiren(party.siren)
        if (isExisted) {
            resolve(false)
        }
        const request = {
            text: 'INSERT INTO political_party (pop_name, pop_description, pop_object, pop_address_street, pop_siren, pop_chart, pop_iban, poe_id, prs_nir, twn_code_insee, pop_date_create, pop_url_logo) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)',
            values: [party.name, party.description, party.object, party.address_street, party.siren, party.chart, party.iban, party.id_political_edge, party.nir, party.town_code_insee, party.date_create, party.url_logo],
        }
        pool.query(request, (error, _) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

/**
 * Récupère tous les partis politiques
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_political_party()',
            values: [],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

/**
 * Récupère tout les partie politique pour les statistiques
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAllPartyForStats = () => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT pop_id as id, pop_name as name  FROM political_party',
            values: [],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

/**
 * Récupère les partis politiques en fonction du filtre
 * @param siren Le SIREN du parti politique
 * @param nir Le NIR de la personne
 * @param includeLeft Inclure les partis où on est plus
 * @param idPoliticalParty L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (nir = null, includeLeft = false, siren = null, idPoliticalParty = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_political_party($1, $2, $3, $4)',
            values: [nir, siren, idPoliticalParty, includeLeft],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

/**
 * Modifie le logo du parti politique
 * @param idLogo L'id du document du logo
 * @param id L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateLogo = (idLogo, id) => {
    return new Promise(async (resolve, reject) => {
        const isExisted = await IfExists(id)
        if (isExisted) {
            resolve(false)
        }
        const request = {
            text: 'UPDATE political_party SET doc_id_logo = $1 WHERE pop_id = $2',
            values: [idLogo, id],
        }
        pool.query(request, (error, _) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

/**
 * Modifie la charte du parti politique
 * @param idChart L'id du document contenant la charte du parti politique
 * @param id L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateChart = (idChart, id) => {
    return new Promise(async (resolve, reject) => {
        const isExisted = await IfExists(id)
        if (isExisted) {
            resolve(false)
        }
        const request = {
            text: 'UPDATE political_party SET doc_id_chart = $1 WHERE pop_id = $2',
            values: [idChart, id],
        }
        pool.query(request, (error, _) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

/**
 * Modifie les détails bancaires du parti politique
 * @param idBankDetails L'id du document contenant les détails bancaires
 * @param id L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateBankDetails = (idBankDetails, id) => {
    return new Promise(async (resolve, reject) => {
        const isExisted = await IfExists(id)
        if (isExisted) {
            resolve(false)
        }
        const request = {
            text: 'UPDATE political_party SET doc_id_bank_details = $1 WHERE pop_id = $2',
            values: [idBankDetails, id],
        }
        pool.query(request, (error, _) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

/**
 * Vérifie si un parti politique existe déjà par le SIREN
 * @param siren Le SIREN du parti
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExistsBySiren = (siren) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM political_party WHERE pop_siren = $1',
            values: [siren],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                if (res && res.count > 0) {
                    resolve(true)
                } else {
                    resolve(false)
                }
            }
        });
    });
}

/**
 * Vérifie si un parti politique existe déjà par son ID
 * @param id L'id du parti politique
 * @returns {Promise<unknown>}
 * @constructor
 */
const IfExists = (id) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM political_party WHERE pop_id = $1',
            values: [id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                if (res && res.count > 0) {
                    resolve(true)
                } else {
                    resolve(false)
                }
            }
        });
    });
}

/**
 * Statistiques : Récupère le nombre d'adhérent sur un parti politique par an et par mois
 * @param nir Le NIR de l'adhérent
 * @param year L'année du tri
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbAdherent = (nir, year = new Date().getFullYear()) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM stats_adherent_from_party($1, $2)',
            values: [nir, year],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

/**
 * Statistiques : Récupère le nombre de meeting et le nombre de participant pour un parti politiue par an et par mois
 * @param nir Le NIR de l'ahdérent
 * @param year L'année du tri
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbMeeting = (nir, year = new Date().getFullYear()) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM stats_meeting_from_party($1, $2)',
            values: [nir, year],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

/**
 * Statistiques : Récupère les cotisations annuelles par parti politique et le total récolté
 * @param nir Le NIR de l'adhérent
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAnnualFee = (nir) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM stats_fee_from_party($1)',
            values: [nir],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

/**
 * Récupère le nombre de message pour chaque thread sur une date donnée
 * @param nir Le NIR de l'utilisateur
 * @param date La date
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbMessageByDay = (nir, date) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM stats_messages_from_party_by_date($1, $2)',
            values: [nir, date],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

/**
 * Récupère le nombre de message pour chaque thread sur une date donnée
 * @param nir Le NIR de l'utilisateur
 * @param year L'année de la recherche'
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetNbMessageByWeeks = (nir, year) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM stats_messages_from_party_by_week($1, $2)',
            values: [nir, year],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows : null
                resolve(res)
            }
        });
    });
}

export default {
    PoliticalParty,
    StatsAdherent,
    StatsMeeting,
    StatsAnnualFee,
    StatsMessageHour,
    StatsMessageWeek,
    Add,
    GetAll,
    Get,
    UpdateLogo,
    UpdateChart,
    UpdateBankDetails,
    IfExistsBySiren,
    IfExists,
    GetNbAdherent,
    GetNbMeeting,
    GetAnnualFee,
    GetNbMessageByDay,
    GetNbMessageByWeeks,
    GetAllPartyForStats
}
