import {pool} from "../middlewares/postgres.mjs";

class Member {
    id
    firstname
    lastname
    date_join
    date_left
    is_left
    mute_thread
    id_thread
    id_adherent
}

/**
 * Récupère l'id d'un membre par le NIR d'une personne
 * @param nir Le NIR de la personne
 * @param idThread L'ID du thread
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetMemberIdByNIR = (nir, idThread) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM get_id_member_by_nir($1, $2)',
            values: [nir, idThread],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res.get_id_member_by_nir)
            }
        });
    });
}

export default {Member, GetMemberIdByNIR}
