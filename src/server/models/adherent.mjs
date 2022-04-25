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
 * Retourne tous les adhérents
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetAll = () => {
    return new Promise((resolve, reject) => {
        const request = `SELECT adh_id        as id,
                                adh_date_join as date_join,
                                adh_date_left as date_left,
                                adh_is_left   as is_left,
                                pop_id        as id_political_party,
                                prs_nir       as nir
                         FROM adherent`
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
 * Récupère les adhérents par filtre
 * @param nir Le NIR (inclus tout le monde si NULL)
 * @param included_left Inclure les adhérents parti
 * @param id_political_party Le partie politique (inclus tous les partis si NULL)
 * @constructor
 */
const Get = (nir = null, included_left = false, id_political_party = null) => {
    return new Promise((resolve, _) => {
        GetAll().then((listAdherent) => {
            if (listAdherent != null) {
                let adherentsFilter = listAdherent.filter(adh => {
                    return ((nir != null && adh.nir === nir) || nir == null) &&
                        ((!included_left && !adh.is_left) || included_left)
                })
                adherentsFilter = (adherentsFilter.count > 0) ? adherentsFilter : null
                resolve(adherentsFilter)
            } else {
                resolve(null)
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
                const request = `INSERT INTO adherent (adh_date_join, pop_id, prs_nir)
                                 VALUES (now(), ${id_political_party}, '${nir}')`
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
                const request = `UPDATE adherent
                                 SET adh_is_left   = true,
                                     adh_date_left = now()
                                 WHERE prs_nir = '${nir}'
                                 AND adh_is_left = false`
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

export default {Adherent, Add, Get, GetAll, Left}
