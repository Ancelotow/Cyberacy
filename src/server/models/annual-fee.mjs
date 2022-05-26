import {pool} from "../middlewares/postgres.mjs";

class AnnualFee {
    year
    id_political_party
    fee
}

/**
 * Get annual fee by id
 * @param year Year of annual fee
 * @param id_political_party Political party of annual fee
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (year = null, id_political_party = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_annual_fee($1, $2)',
            values: [year, id_political_party],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res)
            }
        });
    });
}

/**
 * Ajout une nouvelle cotisation annuelle à un parti politique
 * @param annual_fee La nouvelle cotisation annuelle
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (annual_fee) => {
    return new Promise((resolve, reject) => {
        Get(annual_fee.year, annual_fee.id_political_party).then((result) => {
            if (!result) {
                const request = `INSERT INTO annual_fee (afe_year, pop_id, afe_fee)
                                 VALUES (${annual_fee.year}, ${annual_fee.id_political_party}, ${annual_fee.fee})`
                pool.query(request, (error, _) => {
                    if (error) {
                        reject(error)
                    } else {
                        resolve(true)
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            reject(e)
        });
    });
}

export default {AnnualFee, Get, Add}
