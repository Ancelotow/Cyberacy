import {pool} from "../middlewares/postgres.mjs";

class Color {
    id
    name
    red
    green
    blue
    opacity
}

/**
 * Récupère la liste de toutes les couleurs
 * @returns {Promise<unknown>}
 * @constructor
 */
Color.prototype.Get = function () {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM filter_color()',
            values: [],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let listColors = []
                result.rows.forEach(e => listColors.push(Object.assign(new Color(), e)));
                resolve(listColors)
            }
        });
    });
}

/**
 * Récupère la couleur par son id
 * @param id L'ID de la couleur
 * @returns {Promise<unknown>}
 * @constructor
 */
Color.prototype.GetById = function (id) {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * from filter_color($1)',
            values: [id],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? Object.assign(new Color(), result.rows[0]) : null
                resolve(res)
            }
        });
    });
}

export {Color}
