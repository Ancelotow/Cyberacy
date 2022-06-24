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

function GetLocationFromAddress(address) {
    return new Promise((resolve, reject) => {
        if(address == null) {
            reject("Address is required")
            return
        }
        axios.get(`https://maps.googleapis.com/maps/api/geocode/json/${address}/${process.env.GOOGLE_MAPS_TOKEN}`).then(async (res) => {
            if (res.data) {
                let coordinates = new Coordinates()
                if(res.data.status === "OK") {
                    coordinates
                }
                resolve(coordinates)
            } else {
                resolve(null)
            }
        }).catch((error) => {
            if (error.response.status === 404) {
                reject(error.response)
            } else {
                reject(error)
            }
        });
    });
}
