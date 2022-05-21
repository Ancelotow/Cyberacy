import statsCtrl from "../controllers/stats.controller.mjs";
import express from "express"

const routerStats = express.Router()

routerStats.get("/statistics/political_party/month", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération du nombres d adhérents à un parti politique par mois sur une année.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['year'] = {
           in: 'query',
           description: 'L année pour le tri',
           type: 'int'
    } */

    const year = (req.query.year == null) ? new Date().getFullYear() : req.query.year
    const response = await statsCtrl.GetNbAdherentByMonth(req.data.nir, year)
    res.status(response.status).send(response.data)
});

routerStats.get("/statistics/political_party/year", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération du nombres d adhérents à un parti politique par an.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await statsCtrl.GetNbAdherentByYear(req.data.nir)
    res.status(response.status).send(response.data)
});

export {routerStats}
