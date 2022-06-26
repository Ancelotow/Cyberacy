import {Region} from "../models/region.mjs";
import {Department} from "../models/department.mjs";
import {Town} from "../models/town.mjs";
import axios from "axios";
import {config} from "dotenv";

class Coordinates {

    latitude = 0.00
    longitude = 0.00

    constructor(longitude, latitude) {
        this.latitude = latitude
        this.longitude = longitude
    }

}

/**
 * Récupère la lattitude et longitude en fonction de l'addresse
 * @param address L'adresse
 * @param zip_code  Le code postale
 * @returns {Promise<unknown>}
 * @constructor
 */
function GetLocationFromAddress(address, zip_code) {
    return new Promise((resolve, reject) => {
        if (address === null) {
            reject("Address is required")
            return
        }
        config()
        axios.get(`https://maps.googleapis.com/maps/api/geocode/json?address=${address},${zip_code},France&key=${process.env.GOOGLE_MAPS_TOKEN}`).then(async (res) => {
            if (res.data) {
                if (res.data.status === "OK" && res.data.results !== null) {
                    if (res.data.results.length >= 0) {
                        let geo = res.data.results[0].geometry
                        if (geo !== null) {
                            let loc = geo.location
                            if (loc !== null) {
                                let coordinates = new Coordinates()
                                coordinates.latitude = loc.lat
                                coordinates.longitude = loc.lng
                                resolve(coordinates)
                                return
                            }
                        }
                    }
                }
            }
            resolve(null)
        }).catch((error) => {
            if (error.response.status === 404) {
                reject("Google API not found.")
            } else {
                reject(error.response.status)
            }
        });
    });
}
/**
 * Récupère la liste des régions
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetRegions = () => {
    return new Promise((resolve, _) => {
        new Region().GetAll().then((res) => {
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
        new Department().GetAll().then((res) => {
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
        new Town().GetAll().then((res) => {
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
            new Town().GetByDepartment(code).then((res) => {
                const code = (res) ? 200 : 204;
                resolve({status: code, data: res})
            }).catch((e) => {
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Liste des départements par régions
 * @param code_insee Code INSEE de la région
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetDepartmentByRegion = (code_insee) => {
    return new Promise((resolve, _) => {
        if(!code_insee) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            new Department().GetByRegion(code_insee).then((res) => {
                const code = (res) ? 200 : 204;
                resolve({status: code, data: res})
            }).catch((e) => {
                resolve({status: 500, data: e})
            })
        }
    });
}

/**
 * Rétourne les coordonées géographiques d'un lieu
 * @param address_street L'adresse du lieu
 * @param zip_code La code postal du lieu
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetCoordinates = (address_street, zip_code) => {
    return new Promise((resolve, _) => {
        if(address_street == null || zip_code == null) {
            resolve({status: 400, data: "Missing parameters."})
        } else {
            GetLocationFromAddress(address_street, zip_code).then((res) => {
                const code = (res) ? 200 : 204;
                resolve({status: code, data: res})
            }).catch((e) => {
                resolve({status: 500, data: e})
            })
        }
    });
}


export default {GetRegions, GetDepartments, GetTowns, GetTownsByDepartment, GetDepartmentByRegion, GetCoordinates, GetLocationFromAddress}
