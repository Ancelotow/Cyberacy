import {pool} from "../middlewares/postgres.mjs";
import {Vote} from "./vote.mjs";

class Meeting {
    id
    name
    object
    description
    date_start
    nb_time
    is_aborted
    reason_aborted
    nb_place
    nb_place_vacant
    street_address
    link_twitch
    link_youtube
    id_political_party
    town_code_insee
    vta_rate
    price_excl
    latitude
    longitude
    uuid
    is_participate
    town = null
}

/**
 * Ajoute un nouveau meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.Add = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO meeting (mee_name, mee_object, mee_description, mee_date_start, mee_nb_time, mee_nb_place, mee_address_street, mee_link_twitch, mee_link_youtube, pop_id, twn_code_insee, mee_vta_rate, mee_price_excl, mee_lat, mee_lng) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)',
            values: [this.name, this.object, this.description, this.date_start, this.nb_time, this.nb_place, this.street_address, this.link_twitch, this.link_youtube, this.id_political_party, this.town_code_insee, this.vta_rate, this.price_excl, this.latitude, this.longitude],
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
 * Si le meeting éxiste
 * @param id L'id du meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.IfExists = function (id) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM meeting WHERE mee_id = $1',
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
 * Vérifie si un meeting éxiste par son UUID
 * @param uuid
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.IfExistsWithUUID = function(uuid) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT COUNT(*) FROM meeting WHERE mee_uuid = $1',
            values: [uuid],
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
 * Annule un meeting
 * @param id L'id du meeting
 * @param reason La raison de l'annulation
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.Aborted = function (id, reason) {
    return new Promise((resolve, reject) => {
        this.IfExists(id).then((result) => {
            if (result) {
                const request = {
                    text: 'UPDATE meeting SET mee_is_aborted = true, mee_reason_aborted = $1, mee_date_aborted = now() WHERE mee_id = $2 AND mee_is_aborted = false',
                    values: [reason, id],
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
 * Récupère les informations d'un participant pour générer un QR-Code
 * @param nir Le NIR du participant
 * @param id L'ID du meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.GetParticipantInfo = function (nir, id) {
    return new Promise((resolve, reject) => {
        this.IfExists(id).then((isExists) => {
            if (!isExists) {
                resolve(null)
                return
            }
            const request = {
                text: `select mee.mee_id         as id,
                              mee.mee_name       as name,
                              mee.mee_date_start as date_start,
                              mee.mee_uuid       as uuid,
                              prs_firstname      as firstname,
                              prs_lastname       as lastname,
                              prs_birthday       as birthday,
                              sex_name           as civility
                       from meeting mee
                                join participant ptc on mee.mee_id = ptc.mee_id and ptc.prs_nir = $1 and ptc.ptc_is_aborted = false
                                join person prs on ptc.prs_nir = prs.prs_nir
                                join sex s on prs.sex_id = s.sex_id
                       where mee.mee_id = $2
                       limit 1`,
                values: [nir, id],
            }
            pool.query(request, (error, result) => {
                if (error) {
                    reject(error)
                } else {
                    if (result.rows.length <= 0) {
                        resolve(null)
                    } else {
                        resolve(result.rows[0])
                    }
                }
            });
        }).catch((e) => {
            reject(e)
        })
    });
}

/**
 * Récupère la liste des meetings
 * @param town La ville
 * @param idPoliticalParty L'id du parti politique
 * @param nir Le NIR du participant
 * @param includeAborted Inclus les meetings annulé
 * @param includeCompleted Inclus les meetings complet
 * @param includeFinished Inclus les meetings finis
 * @param id L'id d'un meeting
 * @param onlyMine
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.Get = function (town = null, idPoliticalParty = null, nir = null, includeAborted = false, includeCompleted = true, includeFinished = false, id = null, onlyMine = false) {
    return new Promise((resolve, reject) => {
        const request = {
            text: `select *
                   from filter_meeting($1, $2, $3, $4, $5, $6, $7, $8)`,
            values: [nir, town, idPoliticalParty, includeAborted, includeCompleted, includeFinished, id, onlyMine],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                resolve(result.rows)
            }
        });
    });
}

/**
 * Rétourne un meeting par son ID
 * @param nir Le NIR de l'utilisateur
 * @param id L'ID du meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.GetById = function (nir, id) {
    return new Promise((resolve, reject) => {
        const request = {
            text: `select mee.mee_id                      as id,
                          mee_name                        as name,
                          mee_object                      as object,
                          mee_description                 as description,
                          mee_date_start                  as date_start,
                          mee_nb_time                     as nb_time,
                          mee_is_aborted                  as is_aborted,
                          mee_reason_aborted              as reason_aborted,
                          mee_nb_place                    as nb_place,
                          get_nb_place_vacant(mee.mee_id) as nb_place_vacant,
                          mee_address_street              as address_street,
                          mee_link_twitch                 as link_twitch,
                          mee_link_youtube                as link_youtube,
                          mee.pop_id                      as id_political_party,
                          mee.twn_code_insee              as town_code_insee,
                          mee_vta_rate                    as vta_rate,
                          mee_price_excl                  as price_excl,
                          mee_uuid                        as uuid,
                          mee_lat                         as latitude,
                          mee_lng                         as longitude,
                          case
                              when ptc.prs_nir is not null then true
                              else false
                              end                         as is_participate
                   from meeting mee
                            left join participant ptc on mee.mee_id = ptc.mee_id and ptc.prs_nir = $1
                   where mee.mee_id = $2
                   limit 1`,
            values: [nir, id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                if (result.rows.length > 0) {
                    resolve(Object.assign(new Meeting(), result.rows[0]))
                } else {
                    resolve(null)
                }
            }
        });
    });
}

export {Meeting}
