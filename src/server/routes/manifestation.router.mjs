import manifestationCtrl from "../controllers/manifestation.controller.mjs";
import express from "express"

const routerMan = express.Router()

routerMan.post("/manifestation", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Ajouter une nouvelle manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.AddManifestation(req.body)
    res.status(response.status).send(response.data)
});

routerMan.patch("/manifestation/aborted", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Annuler une manifestation existante.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.AbortedManifestation(req.body.id, req.body.reason)
    res.status(response.status).send(response.data)
});

routerMan.get("/manifestation", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Récupération des manifestations.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['includeAborted'] = {
	       in: 'query',
           description: 'Inclure les manifestation annuler.',
           type: 'boolean'
    } */
    /* #swagger.parameters['mine'] = {
          in: 'query',
          description: 'Voir uniquement les manifestation auxquelles je participe.',
          type: 'boolean'
   } */

    const nir = (req.query.mine && req.query.mine === 'true') ? req.data.nir : null
    const response = await manifestationCtrl.GetAllManifestations(req.query.includeAborted, nir)
    res.status(response.status).send(response.data)
});

routerMan.post("/manifestation/:id/participate", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Participer à une manifestations.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['id'] = {
	       in: 'parameter',
           description: 'Id de la manifestation.',
           type: 'number'
    } */
    const nir = req.data.nir
    const response = await manifestationCtrl.Participate(nir, req.params.id)
    res.status(response.status).send(response.data)
});

routerMan.post("/manifestation/option", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Ajouter une option à une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.AddOption(req.body)
    res.status(response.status).send(response.data)
});

routerMan.get("/manifestation/:id/option", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Récupérer les options de une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.GetOptions(req.params.id)
    res.status(response.status).send(response.data)
});

routerMan.delete("/manifestation/option/:id", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Supprimer une option de une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.DeleteOption(req.params.id)
    res.status(response.status).send(response.data)
});

routerMan.post("/manifestation/step", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Ajouter une étape à une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.AddStep(req.body)
    res.status(response.status).send(response.data)
});

routerMan.get("/manifestation/:id/step", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Récupérer les étapes d\'une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.GetSteps(req.params.id)
    res.status(response.status).send(response.data)
});

routerMan.delete("/manifestation/step/:id", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Supprimer une étape de une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.DeleteStep(req.params.id)
    res.status(response.status).send(response.data)
});


export {routerMan}
