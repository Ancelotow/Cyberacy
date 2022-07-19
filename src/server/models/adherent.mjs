import {pool} from "../middlewares/postgres.mjs";

class Adherent {
    id
    date_join
    date_left
    is_left
    id_political_party
    nir
}

/**
 * Récupère les adhérents
 * @param nir Le NIR (inclus tout le monde si NULL)
 * @param included_left Inclure les adhérents parti
 * @param id_political_party Le partie politique (inclus tous les partis si NULL)
 * @constructor
 */
const Get = (nir = null, included_left = false, id_political_party = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_adherent($1, $2, $3)',
            values: [nir, id_political_party, included_left],
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
 * Ajoute un nouvel adhérent
 * @param nir Le NIR de l'adhérent
 * @param id_political_party l'id du parti politique auxquels adhère la personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (nir, id_political_party) => {
    return new Promise((resolve, reject) => {
        Get(nir).then((result) => {
            if (!result) {
                const request = {
                    text: 'INSERT INTO adherent (adh_date_join, pop_id, prs_nir) VALUES (now(), $1, $2)',
                    values: [id_political_party, nir],
                }
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

/**
 * Part d'un parti politique
 * @param nir Le NIR de la personne qui part
 * @returns {Promise<unknown>}
 * @constructor
 */
const Left = (nir) => {
    return new Promise((resolve, reject) => {
        Get(nir, false, null).then((result) => {
            if (result) {
                const request = {
                    text: `UPDATE adherent SET adh_is_left = true, adh_date_left = now() WHERE prs_nir = $1 AND adh_is_left = false`,
                    values: [nir],
                }
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

/**
 * Récupère l'id de l'adhérent en fonction du NIR et du thread
 * @param nir Le NIR de la personne
 * @param idThread L'id du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAdherentIdByNIR = (nir, idThread) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM get_id_adherent_by_nir($1, $2)',
            values: [nir, idThread],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res.get_id_adherent_by_nir)
            }
        });
    });
}

export default {Adherent, Add, Get, Left, GetAdherentIdByNIR}
