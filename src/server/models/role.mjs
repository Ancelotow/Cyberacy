import {pool} from "../middlewares/postgres.mjs";

class Role {
    id
    title
    description
    code
}

/**
 * Récupère la liste des rôles
 * @param nir Le NIR de l'utilisateur
 * @param profile Le profile pour le tri
 * @returns {Promise<unknown>}
 * @constructor
 */
const Get = (nir, profile = null) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_role($1, $2)',
            values: [nir, profile],
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
    Role,
    Get
}
