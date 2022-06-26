import {CronJob} from 'cron'
import axios from 'axios'
import region from "../models/region.mjs";
import town from "../models/town.mjs";
import {Department} from "../models/department.mjs";

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

/**
 * Insère les départements (Tout les Lundi à 03:00)
 * @type {CronJob}
 */
const jobDepartment = new CronJob('* 0 3 * * 1', function () {
    axios.get(uri_api_gouv + 'departements').then(async (res) => {
        if (res.data) {
            let nom
            for (const dept of res.data) {
                nom = dept.nom.replace('\'', '\'\'')
                try {
                    await department.Add({code: dept.code, name: nom, region_code_insee: dept.codeRegion})
                } catch (e) {
                    console.error(e)
                }
            }
        }
    });
}, null, true, 'Europe/Paris');

/**
 * Insère les communes (Tout les Lundi à 03:00)
 */
const jobTown = new CronJob('* 0 3 * * 1', function () {
    new Department().GetAll().then((listDept) => {
        for (const dept of listDept) {
            axios.get(uri_api_gouv + 'departements/' + dept.code + '/communes').then(async (res) => {
                if (res.data) {
                    let nom
                    for (const twn of res.data) {
                        nom = twn.nom.replace('\'', '\'\'')
                        try {
                            await town.Add({
                                name: nom,
                                code_insee: twn.code,
                                zip_code: twn.codesPostaux[0],
                                nb_resident: twn.population,
                                department_code: twn.codeDepartement
                            })
                        } catch (e) {
                            console.error(e)
                        }
                    }
                }
            });
        }
    });
}, null, true, 'Europe/Paris');


const startJob = () => {
    jobRegion.start()
    jobDepartment.start()
    jobTown.start()
}

export default {startJob}
