import messagingCtrl from "../controllers/messaging.controller.mjs";
import express from "express"

const routerMsg = express.Router()

routerMsg.post("/thread", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Ajout d un nouveau Thread.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.AddThread(req.body)
    res.status(response.status).send(response.data)
});

routerMsg.patch("/thread/:id/main/:id_political_party", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Modifie le thread principal d un parti politique'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.ChangeMainThread(req.params.id, req.params.id_political_party)
    res.status(response.status).send(response.data)
});

routerMsg.delete("/thread/:id", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Supprime un thread existant'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.DeleteThread(req.params.id)
    res.status(response.status).send(response.data)
});

routerMsg.put("/thread", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Modifie un thread'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.UpdateThread(req.body)
    res.status(response.status).send(response.data)
});

export {routerMsg}
