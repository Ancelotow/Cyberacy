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
}

/**
 * Ajoute un nouveau parti politique
 * @param party
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (party) => {
    return new Promise((resolve, reject) => {
        const description = (party.description == null) ? null : `'${party.description}'`
        const chart = (party.chart == null) ? null : `'${party.chart}'`
        const iban = (party.iban == null) ? null : `'${party.iban}'`
        const url_bank_details = (party.url_bank_details == null) ? null : `'${party.url_bank_details}'`
        const url_chart = (party.url_chart == null) ? null : `'${party.url_chart}'`
        const date_create = (party.date_create == null) ? `'${new Date()}'` : `'${FormaterDate(party.date_create)}'`
        const request = `INSERT INTO political_party (pop_name, pop_url_logo, pop_description, pop_object,
                                                      pop_address_street, pop_siren, pop_chart, pop_iban,
                                                      pop_url_bank_details, pop_url_chart, poe_id, prs_nir,
                                                      twn_code_insee, pop_date_create)
                         VALUES ('${party.name}', '${party.url_logo}', ${description}, '${party.object}',
                                 '${party.address_street}', '${party.siren}', ${chart}, ${iban}, ${url_bank_details},
                                 ${url_chart}, ${party.id_political_edge}, '${party.nir}', '${party.town_code_insee}',
                                 ${date_create})`
        pool.query(request, (error, _) => {
            if (error) {
                reject(error)
            } else {
                resolve(true)
            }
        });
    });
}

export default {PoliticalParty, Add}
