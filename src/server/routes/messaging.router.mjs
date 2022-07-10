import messagingCtrl from "../controllers/messaging.controller.mjs";
import express from "express"

const routerMsg = express.Router()

routerMsg.get("/thread", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Récupère les thread'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['onlyMine'] = {
         in: 'query',
         description: 'Uniquement les threads où je suis',
         type: 'boolean'
    } */

    const onlyMine = (req.query.onlyMine == null) ? false : req.query.onlyMine
    const response = await messagingCtrl.GetThread(req.data.nir, onlyMine)
    res.status(response.code).send(response)
});

routerMsg.post("/thread", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Ajout d un nouveau Thread.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['thread'] = {
                       in: 'body',
                       description: 'Le nouveau thread',
                       schema: { $ref: '#/definitions/AddThread' }
    } */

    const response = await messagingCtrl.AddThread(req.body)
    res.status(response.code).send(response)
});

routerMsg.patch("/thread/:id/main/:id_political_party", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Modifie le thread principal d un parti politique'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.ChangeMainThread(req.params.id, req.params.id_political_party)
    res.status(response.code).send(response)
});

routerMsg.delete("/thread/:id", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Supprime un thread existant'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.DeleteThread(req.params.id)
    res.status(response.code).send(response)
});

routerMsg.put("/thread", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Modifie un thread'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['thread'] = {
                       in: 'body',
                       description: 'Le thread modifié',
                       schema: { $ref: '#/definitions/UpdateThread' }
    } */

    const response = await messagingCtrl.UpdateThread(req.body)
    res.status(response.code).send(response)
});

routerMsg.get("/thread/:id/message", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Récupère les messages un thread'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.GetMessage(req.data.nir, req.params.id)
    res.status(response.code).send(response)
});

routerMsg.post("/thread/:id/message", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Publier un nouveau message sur un thread donné.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['thread'] = {
                       in: 'body',
                       description: 'Le nouveau message',
                       schema: { $ref: '#/definitions/AddMessage' }
    } */

    const response = await messagingCtrl.AddMessage(req.data, req.params.id, req.body)
    res.status(response.code).send(response)
});

routerMsg.get("/thread/:id/member", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Voir les membres du thread'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.GetMember(req.data.nir, req.params.id)
    res.status(response.code).send(response)
});

routerMsg.post("/thread/:id/join", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Rejoindre le thread'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.JoinThread(req.data.nir, req.params.id)
    res.status(response.code).send(response)
});

routerMsg.delete("/thread/:id/left", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Quitter le thread'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await messagingCtrl.LeftThread(req.data.nir, req.params.id)
    res.status(response.code).send(response)
});

routerMsg.patch("/thread/:id/mute/:mute", async (req, res) => {
    // #swagger.tags = ['Messaging']
    // #swagger.description = 'Mute/Unmute le thread'
    // #swagger.security = [{ "Bearer": [] }]
    
    const mute = (req.params.mute === 'true');
    const response = await messagingCtrl.MuteThread(req.data.nir, req.params.id, mute)
    res.status(response.code).send(response)
});

export {routerMsg}
