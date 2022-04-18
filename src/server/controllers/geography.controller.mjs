import region from "../models/region.mjs";
import department from "../models/department.mjs";
import town from "../models/town.mjs";

/**
 * Récupère la liste des régions
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetRegions = () => {
    return new Promise((resolve, _) => {
        region.GetAll().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Récupère la liste des régions
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetDepartments = () => {
    return new Promise((resolve, _) => {
        department.GetAll().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Récupère la liste des communes
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetTowns = () => {
    return new Promise((resolve, _) => {
        town.GetAll().then((res) => {
            const code = (res) ? 200 : 204;
            resolve({status: code, data: res})
        }).catch((e) => {
            resolve({status: 500, data: e})
        })
    });
}

/**
 * Liste des communes par départements
 * @param code Code départements
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetTownsByDepartment = (code) => {

    return new Promise((resolve, _) => {
        if(!code) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            town.GetByDepartment(code).then((res) => {
                const code = (res) ? 200 : 204;
                resolve({status: code, data: res})
            }).catch((e) => {
                resolve({status: 500, data: e})
            })
        }
    });
}


export default {GetRegions, GetDepartments, GetTowns, GetTownsByDepartment}
