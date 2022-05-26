import referencesCtrl from "../controllers/references.controller.mjs";
import express from "express"

const routerRef = express.Router()

routerRef.get("/type_step", async (req, res) => {
    // #swagger.tags = ['References']
    // #swagger.description = 'Récupération des types d'étapes pour le trajet des manifestations.'

    const response = await referencesCtrl.GetTypeStep()
    res.status(response.status).send(response.data)
});

routerRef.get("/sex", async (req, res) => {
    // #swagger.tags = ['References']
    // #swagger.description = 'Récupération des civilités.'

    const response = await referencesCtrl.GetSex()
    res.status(response.status).send(response.data)
});

routerRef.get("/type_vote", async (req, res) => {
    // #swagger.tags = ['References']
    // #swagger.description = 'Récupération des types de vote.'

    const response = await referencesCtrl.GetTypeVote()
    res.status(response.status).send(response.data)
});

routerRef.get("/political_edge", async (req, res) => {
    // #swagger.tags = ['References']
    // #swagger.description = 'Récupération des bords politiques.'

    const response = await referencesCtrl.GetPoliticalEdge()
    res.status(response.status).send(response.data)
});

export {routerRef}
