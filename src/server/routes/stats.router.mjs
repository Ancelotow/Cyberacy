import statsCtrl from "../controllers/stats.controller.mjs";
import express from "express"
import {ResponseApi} from "../models/response-api.mjs";

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

    if (req.query.sort === "year") {
        const response = await statsCtrl.GetNbAdherentByYear(req.data.nir)
        res.status(response.code).send(response)
    } else if (req.query.sort === "month") {
        const year = (req.query.year == null) ? new Date().getFullYear() : req.query.year
        const response = await statsCtrl.GetNbAdherentByMonth(req.data.nir, year)
        res.status(response.code).send(response)
    } else {
        res.status(400).send(new ResponseApi().InitBadRequest("The parameters \"sort\" is required"))
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

    }
    #swagger.parameters['year'] = {
           in: 'query',
           description: 'L\'année pour le tri',
           type: 'int'

    }
     #swagger.parameters['idPoliticalParty'] = {
           in: 'query',
           description: 'L\'id d\'un parti politique, NULL récupérant tout (à NULL par défault)',
           type: 'int'

    }*/

    if (req.query.sort === "year") {
        const response = await statsCtrl.GetNbMeetingByYear(req.data.nir, req.query.idPoliticalParty)
        res.status(response.code).send(response)
    } else if (req.query.sort === "month") {
        const year = (req.query.year == null) ? new Date().getFullYear() : req.query.year
        const response = await statsCtrl.GetNbMeetingByMonth(req.data.nir, year, req.query.idPoliticalParty)
        res.status(response.code).send(response)
    } else {
        res.status(400).send(new ResponseApi().InitBadRequest("The parameters \"sort\" is required"))
    }
});

routerStats.get("/statistics/political_party/annual_fee", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération des cotisations annuelles sur un parti politique avec le total récolté.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await statsCtrl.GetAnnualFee(req.data.nir)
    res.status(response.code).send(response)
});

routerStats.get("/statistics/political_party/messages", async (req, res) => {
    /*
       #swagger.tags = ['Statistiques']
       #swagger.description = 'Récupération du nombre de message.'
       #swagger.security = [{ "Bearer": [] }]
       #swagger.parameters['sort'] = {
              in: 'query',
              description: 'Trier par heure (hour), par semaine (week)'
       }
       #swagger.parameters['day'] = {in: 'query', description: 'La date pour le tri', type: 'date' }
       #swagger.parameters['year'] = {in: 'query', description: 'L\'année pour le tri', type: 'number' }
   */

    let response;
    if (req.query.sort === "hour") {
        const day = (req.query.day == null) ? new Date() : req.query.day
        response = await statsCtrl.GetMessagesByDate(req.data.nir, day)
    } else if (req.query.sort === "week") {
        const year = (req.query.year == null) ? new Date().getFullYear() : req.query.year
        response = await statsCtrl.GetMessagesByWeeks(req.data.nir, year)
    } else {
        response = new ResponseApi().InitBadRequest("The parameters \"sort\" is required")
    }
    res.status(response.code).send(response)
});

routerStats.get("/statistics/vote/abstention", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération des statistiques d\'abstention aux votes.'
    // #swagger.security = [{ "Bearer": [] }]
    // #swagger.parameters['typeVote'] = {in: 'query', description: 'Trié par type de vote (NULL pour tout inclure)', type: 'number' }
    // #swagger.parameters['numRound'] = {in: 'query', description: 'Le numéro du tour de vote', type: 'number' }

    const numRound = (req.query.numRound == null) ? 1 : req.query.numRound
    const response = await statsCtrl.GetVoteAbstention(numRound, req.query.typeVote)
    res.status(response.code).send(response)
});

routerStats.get("/statistics/vote/participation", async (req, res) => {
    // #swagger.tags = ['Statistiques']
    // #swagger.description = 'Récupération des statistiques de participation aux votes.'
    // #swagger.security = [{ "Bearer": [] }]
    // #swagger.parameters['typeVote'] = {in: 'query', description: 'Trié par type de vote (NULL pour tout inclure)', type: 'number' }
    // #swagger.parameters['numRound'] = {in: 'query', description: 'Le numéro du tour de vote', type: 'number' }

    const numRound = (req.query.numRound == null) ? 1 : req.query.numRound
    const response = await statsCtrl.GetVoteParticipation(numRound, req.query.typeVote)
    res.status(response.code).send(response)
});

export {routerStats}
