import {CronJob} from 'cron'
import axios from 'axios'

const uri_api_gouv = 'https://geo.api.gouv.fr/'

/**
 * Insère les régions (Tout les Lundi à 03:00)
 * @type {CronJob}
 */
const jobRegion = new CronJob('* 0 3 * * 1', function () {
    //exemple d'initialisation de cron
}, null, true, 'Europe/Paris');



const startJob = () => {
    //jobRegion.start()
}

export default {startJob}
