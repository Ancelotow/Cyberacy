import statsCtrl from "../controllers/stats.controller.mjs";
import express from "express"

const routerStats = express.Router()

routerStats.get("/statistics/political_party/adherent", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération du nombres d adhérents à un parti politique par mois sur une année.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['sort'] = {
           in: 'query',
           description: 'Trier par ans (year) ou par mois (month)',
           schema: {
                '@enum': ['year', 'month']
            }

    } */
    /*  #swagger.parameters['year'] = {
           in: 'query',
           description: 'L année pour le tri',
           type: 'int'

    } */

    if(req.query.sort === "year"){
        const response = await statsCtrl.GetNbAdherentByYear(req.data.nir)
        res.status(response.status).send(response.data)
    } else if (req.query.sort === "month"){
        const year = (req.query.year == null) ? new Date().getFullYear() : req.query.year
        const response = await statsCtrl.GetNbAdherentByMonth(req.data.nir, year)
        res.status(response.status).send(response.data)
    } else {
        res.status(400).send("The parameters \"sort\" is required")
    }
});

routerStats.get("/statistics/political_party/meeting", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération du nombres de meeting et de pariticpation sur un parti politique par mois sur une année.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['sort'] = {
           in: 'query',
           description: 'Trier par ans (year) ou par mois (month)',
           schema: {
                '@enum': ['year', 'month']
            }

    } */
    /*  #swagger.parameters['year'] = {
           in: 'query',
           description: 'L année pour le tri',
           type: 'int'

    } */

    if(req.query.sort === "year"){
        const response = await statsCtrl.GetNbMeetingByYear(req.data.nir)
        res.status(response.status).send(response.data)
    } else if (req.query.sort === "month"){
        const year = (req.query.year == null) ? new Date().getFullYear() : req.query.year
        const response = await statsCtrl.GetNbMeetingByMonth(req.data.nir, year)
        res.status(response.status).send(response.data)
    } else {
        res.status(400).send("The parameters \"sort\" is required")
    }
});

routerStats.get("/statistics/political_party/annual_fee", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération des cotisations annuelles sur un parti politique avec le total récolté.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await statsCtrl.GetAnnualFee(req.data.nir)
    res.status(response.status).send(response.data)
});

routerStats.get("/statistics/political_party/messages", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération du nombre de message.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['sort'] = {
           in: 'query',
           description: 'Trier par jour (day)',
           schema: {
                '@enum': ['day']
            }

    } */
    /*  #swagger.parameters['day'] = {
           in: 'query',
           description: 'La date pour le tri',
           type: 'date'
    } */

    const response = await statsCtrl.GetMessagesByDate(req.data.nir, req.query.day)
    res.status(response.status).send(response.data)
});

export {routerStats}
