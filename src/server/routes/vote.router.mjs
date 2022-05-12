import voteCtrl from "../controllers/vote.controller.mjs";
import express from "express"

const routerVote = express.Router()

routerVote.post("/vote", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Ajout de un nouveau vote.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.AddVote(req.body)
    res.status(response.status).send(response.data)
});

routerVote.get("/vote", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Récupère les votes.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['includeFinish'] = {
         in: 'query',
         description: 'Inclure les votes passés (exclus par défaut)',
         type: 'boolean'
    } */
    /* #swagger.parameters['includeFuture'] = {
         in: 'query',
         description: 'Inclure les futures votes (include pas défaut)',
         type: 'boolean'
    } */
    /* #swagger.parameters['idTypeVote'] = {
         in: 'query',
         description: 'Le type de votes',
         type: 'int'
    } */

    const includeFinish = (req.query.includeFinish == null) ? false : req.query.includeFinish
    const includeFuture = (req.query.includeFuture == null) ? true : req.query.includeFuture
    const response = await voteCtrl.GetVote(req.data.nir, includeFinish, includeFuture, req.query.idTypeVote)
    res.status(response.status).send(response.data)
});

routerVote.post("/vote/:id/round", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Ajout de un nouveau tour de vote.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.AddRound(req.body, req.params.id)
    res.status(response.status).send(response.data)
});

routerVote.get("/round", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Récupère les tours de vote.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['includeFinish'] = {
         in: 'query',
         description: 'Inclure les votes passés (exclus par défaut)',
         type: 'boolean'
    } */
    /* #swagger.parameters['includeFuture'] = {
         in: 'query',
         description: 'Inclure les futures votes (include pas défaut)',
         type: 'boolean'
    } */
    /* #swagger.parameters['idTypeVote'] = {
         in: 'query',
         description: 'Le type de votes',
         type: 'int'
    } */
    /* #swagger.parameters['idVote'] = {
         in: 'query',
         description: 'Le vote',
         type: 'int'
    } */

    const includeFinish = (req.query.includeFinish == null) ? false : req.query.includeFinish
    const includeFuture = (req.query.includeFuture == null) ? true : req.query.includeFuture
    const response = await voteCtrl.GetRound(req.data.nir, includeFinish, includeFuture, req.query.idTypeVote, req.query.idVote)
    res.status(response.status).send(response.data)
});

export {routerVote}
