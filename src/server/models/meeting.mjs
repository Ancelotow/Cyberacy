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
    is_participate
    town = null
}

/**
 * Ajoute un nouveau meeting
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.Add = function() {
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
Meeting.prototype.IfExists = function(id) {
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
 * Annule un meeting
 * @param id L'id du meeting
 * @param reason La raison de l'annulation
 * @returns {Promise<unknown>}
 * @constructor
 */
Meeting.prototype.Aborted = function(id, reason) {
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
Meeting.prototype.Get = function(town = null, idPoliticalParty = null, nir = null, includeAborted = false, includeCompleted = true, includeFinished = false, id = null, onlyMine = false) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_meeting($1, $2, $3, $4, $5, $6, $7, $8)',
            values: [nir, town, idPoliticalParty, includeAborted, includeCompleted, includeFinished, id, onlyMine],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listMeetings = []
                result.rows.forEach(e => listMeetings.push(Object.assign(new Meeting(), e)));
                resolve(listMeetings)
            }
        });
    });
}

export {Meeting}
