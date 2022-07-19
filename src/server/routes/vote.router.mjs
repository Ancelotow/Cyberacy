import voteCtrl from "../controllers/vote.controller.mjs";
import express from "express"
import {ResponseApi} from "../models/response-api.mjs";

const routerVote = express.Router()

routerVote.post("/election", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Ajout de une nouvelle élection.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['election'] = {
                               in: 'body',
                               description: 'La nouvelle élection',
                               schema: { $ref: '#/definitions/AddElection' }
    } */

    const response = await voteCtrl.AddElection(req.body)
    res.status(response.code).send(response)
});

routerVote.get("/election", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Récupère la liste des élections.'
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
    /* #swagger.parameters['idElection'] = {
        in: 'query',
        description: 'L\'id d\'une élection recherchée',
        type: 'number'
   } */

    const includeFinish = (req.query.includeFinish == null) ? false : req.query.includeFinish
    const includeFuture = (req.query.includeFuture == null) ? true : req.query.includeFuture
    const response = await voteCtrl.GetElection(req.data.nir, req.query.idElection, includeFinish, includeFuture)
    res.status(response.code).send(response)
});

routerVote.post("/election/:id/vote", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Ajout de un nouveau vote.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['vote'] = {
                               in: 'body',
                               description: 'Le nouveau vote',
                               schema: { $ref: '#/definitions/AddVote' }
    } */

    const response = await voteCtrl.AddVote(req.body, req.query.id)
    res.status(response.code).send(response)
});

routerVote.get("/election/:id/vote", async (req, res) => {
    // #swagger.tags = ['Election']
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
    res.status(response.code).send(response)
});

routerVote.get("/vote/in_progress", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Récupère les votes en cours d\'un utilisateur.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.GetVoteInProgress(req.data.nir)
    res.status(response.code).send(response)
});

routerVote.get("/vote/:id/details", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Récupère un vote en détail.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.GetVoteDetails(req.data.nir, req.params.id)
    res.status(response.code).send(response)
});

routerVote.post("/vote/:id/round", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Ajout de un nouveau tour de vote.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['round'] = {
                               in: 'body',
                               description: 'Le nouveau tour de vote',
                               schema: { $ref: '#/definitions/AddRoundVote' }
    } */

    const response = await voteCtrl.AddRound(req.body, req.params.id)
    res.status(response.code).send(response)
});

routerVote.get("/vote/:id/round", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Récupère les tours de vote.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.GetRound(req.data.nir, req.params.id)
    res.status(response.code).send(response)
});

routerVote.post("/vote/:id_vote/choice", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Ajout d\'un nouveau choix pour un vote.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['choice'] = {
                               in: 'body',
                               description: 'Le nouveau tour de vote',
                               schema: { $ref: '#/definitions/AddChoice' }
    } */


    const response = await voteCtrl.AddChoice(req.body, req.params.id_vote)
    res.status(response.code).send(response)
});

routerVote.delete("/vote/choice/:id_choice", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Supprime un choix de vote existant'
    // #swagger.security = [{ "Bearer": [] }]


    const response = await voteCtrl.DeleteChoice(req.params.id_choice)
    res.status(response.code).send(response)
});

routerVote.get("/vote/:id_vote/round/:num_round/choice", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Récupère les choix pour un tour de vote donné.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.GetChoice(req.data.nir, req.params.num_round, req.params.id_vote)
    res.status(response.code).send(response)
});

routerVote.get("/vote/:id_vote/round/:num_round/results", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Récupère les résultats pour un tour de vote donné.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.GetVoteResults(req.data.nir, req.params.id_vote, req.params.num_round)
    res.status(response.code).send(response)
});

routerVote.post("/vote/:id_vote/round/:num_round", async (req, res) => {
    // #swagger.tags = ['Election']
    // #swagger.description = 'Voter pour un tour de vote donné'
    // #swagger.security = [{ "Bearer": [] }]


    const response = await voteCtrl.ToVote(req.data.nir, req.params.num_round, req.params.id_vote, req.body)
    res.status(response.code).send(response)
});

export {routerVote}
