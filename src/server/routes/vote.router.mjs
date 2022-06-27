import voteCtrl from "../controllers/vote.controller.mjs";
import express from "express"

const routerVote = express.Router()

routerVote.post("/election/:id/vote", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Ajout de un nouveau vote.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['vote'] = {
                               in: 'body',
                               description: 'Le nouveau vote',
                               schema: { $ref: '#/definitions/AddVote' }
    } */

    const response = await voteCtrl.AddVote(req.body, req.query.id)
    res.status(response.status).send(response.data)
});

routerVote.get("/election/:id/vote", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Récupère les votes d'une élection.'
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
    const response = await voteCtrl.GetVote(req.data.nir, req.params.id, includeFinish, includeFuture)
    res.status(response.status).send(response.data)
});

routerVote.post("/vote/:id/round", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Ajout de un nouveau tour de vote.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['round'] = {
                               in: 'body',
                               description: 'Le nouveau tour de vote',
                               schema: { $ref: '#/definitions/AddRoundVote' }
    } */

    const response = await voteCtrl.AddRound(req.body, req.params.id)
    res.status(response.status).send(response.data)
});

routerVote.get("/vote/:id/round", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Récupère les tours de vote.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.GetRound(req.data.nir, req.params.id)
    res.status(response.status).send(response.data)
});

routerVote.post("/vote/:id_vote/round/:num_round/choice", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Ajout de un nouveau choix.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['choice'] = {
                               in: 'body',
                               description: 'Le nouveau tour de vote',
                               schema: { $ref: '#/definitions/AddChoice' }
    } */


    const response = await voteCtrl.AddChoice(req.body, req.params.id_vote, req.params.num_round)
    res.status(response.status).send(response.data)
});

routerVote.get("/vote/:id_vote/round/:num_round/choice", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Récupère les choix pour un tour de vote donné.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.GetChoice(req.data.nir, req.params.num_round, req.params.id_vote)
    res.status(response.status).send(response.data)
});

routerVote.post("/vote/:id_vote/round/:num_round", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Voter pour un tour de vote donné'
    // #swagger.security = [{ "Bearer": [] }]

    let idChoice;
    try{
        idChoice = parseInt(req.body)
    } catch (e) {
        res.status(400).send(e.message)
    }
    const response = await voteCtrl.ToVote(req.data.nir, req.params.num_round, req.params.id_vote, idChoice)
    res.status(response.status).send(response.data)
});

export {routerVote}
