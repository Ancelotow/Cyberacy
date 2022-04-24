import partyCtrl from "../controllers/party.controller.mjs";
import express from "express"

const routerParty = express.Router()

routerParty.post("/political_party", async (req, res) => {
    // #swagger.tags = ['Parti politique']
    // #swagger.description = 'Ajout d'un nouveau parti politique si il éxiste dans la BDD de INSEE.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.AddParty(req.body)
    res.status(response.status).send(response.data)
});

export {routerParty}
