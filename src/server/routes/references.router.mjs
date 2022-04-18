import referencesCtrl from "../controllers/references.controller.mjs";
import express from "express"

const routerRef = express.Router()

routerRef.get("/step_type", async (req, res) => {
    // #swagger.tags = ['References']
    // #swagger.description = 'Récupération des types d'étapes pour le trajet des manifestations.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await referencesCtrl.GetTypeStep()
    res.status(response.status).send(response.data)
});

export {routerRef}
