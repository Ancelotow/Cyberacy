import {CronJob} from 'cron'
import axios from 'axios'
import region from "../models/region.mjs";

const uri_api_gouv = 'https://geo.api.gouv.fr/'

/**
 * Insère les régions (Tout les Lundi à 03:00)
 * @type {CronJob}
 */
const jobRegion = new CronJob('* 0 3 * * 1', function () {
    axios.get(uri_api_gouv + 'regions').then(async (res) => {
        if (res.data) {
            let nom
            for (const reg of res.data) {
                nom = reg.nom.replace('\'', '\'\'')
                try {
                    await region.Add({code_insee: reg.code, name: nom})
                } catch (e) {
                    console.error(e)
                }
            }
        }
    });
}, null, true, 'Europe/Paris');


const startJob = () => {
}

export default {startJob}
