import manifestationCtrl from "../controllers/manifestation.controller.mjs";
import express from "express"

const routerMan = express.Router()

routerMan.post("/manifestation", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Ajouter une nouvelle manifestation.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['manifestation'] = {
                               in: 'body',
                               description: 'La nouvelle manifestation',
                               schema: { $ref: '#/definitions/AddManifestation' }
    } */

    const response = await manifestationCtrl.AddManifestation(req.body)
    res.status(response.code).send(response)
});

routerMan.patch("/manifestation/aborted", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Annuler une manifestation existante.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['manifestation'] = {
                               in: 'body',
                               description: 'Raison de l annulation de la manifestation',
                               schema: { $ref: '#/definitions/Aborted' }
    } */

    const response = await manifestationCtrl.AbortedManifestation(req.body.id, req.body.reason)
    res.status(response.code).send(response)
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
    res.status(response.code).send(response)
});

routerMan.post("/manifestation/:id/participate", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Participer à une manifestations.'
    // #swagger.security = [{ "Bearer": [] }]

    const nir = req.data.nir
    const response = await manifestationCtrl.Participate(nir, req.params.id)
    res.status(response.code).send(response)
});

routerMan.post("/manifestation/option", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Ajouter une option à une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['option'] = {
                               in: 'body',
                               description: 'La nouvelle option de manifestation',
                               schema: { $ref: '#/definitions/AddOptionManifestation' }
    } */

    const response = await manifestationCtrl.AddOption(req.body)
    res.status(response.code).send(response)
});

routerMan.get("/manifestation/:id/option", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Récupérer les options de une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.GetOptions(req.params.id)
    res.status(response.code).send(response)
});

routerMan.delete("/manifestation/option/:id", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Supprimer une option de une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.DeleteOption(req.params.id)
    res.status(response.code).send(response)
});

routerMan.post("/manifestation/step", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Ajouter une étape à une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['step'] = {
                               in: 'body',
                               description: 'La nouvelle étape de manifestation',
                               schema: { $ref: '#/definitions/AddStepManifestation' }
    } */

    const response = await manifestationCtrl.AddStep(req.body)
    res.status(response.code).send(response)
});

routerMan.get("/manifestation/:id/step", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Récupérer les étapes d\'une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.GetSteps(req.params.id)
    res.status(response.code).send(response)
});

routerMan.delete("/manifestation/step/:id", async (req, res) => {
    // #swagger.tags = ['Manifestation']
    // #swagger.description = 'Supprimer une étape de une manifestation.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await manifestationCtrl.DeleteStep(req.params.id)
    res.status(response.code).send(response)
});


export {routerMan}
