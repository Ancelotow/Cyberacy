import partyCtrl from "../controllers/party.controller.mjs";
import express from "express"

const routerParty = express.Router()

routerParty.post("/political_party", async (req, res) => {
    // #swagger.tags = ['Parti politique']
    // #swagger.description = 'Ajout de un nouveau parti politique si il éxiste dans la BDD de INSEE.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.AddParty(req.body)
    res.status(response.status).send(response.data)
});

routerParty.get("/political_party", async (req, res) => {
    // #swagger.tags = ['Parti politique']
    // #swagger.description = 'Récupération des partis politiques.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['siren'] = {
	       in: 'query',
           description: 'Recherher par le SIREN.',
           type: 'string'
    } */
    const siren = (req.query.siren == null) ?  null : req.query.siren
    const response = await partyCtrl.GetAllParty(siren)
    res.status(response.status).send(response.data)
});

export {routerParty}
