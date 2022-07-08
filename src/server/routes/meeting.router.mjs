import meetingCtrl from "../controllers/meeting.controller.mjs"
import express from "express"

const routerMee = express.Router()

routerMee.post("/meeting", async (req, res) => {
    // #swagger.tags = ['Meeting']
    // #swagger.description = 'Ajoute un nouveau meeting.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['meeting'] = {
                               in: 'body',
                               description: 'Le nouveau meeting',
                               schema: { $ref: '#/definitions/AddMeeting' }
    } */

    const response = await meetingCtrl.AddMeeting(req.body)
    res.status(response.status).send(response.data)
});

routerMee.patch("/meeting/aborted", async (req, res) => {
    // #swagger.tags = ['Meeting']
    // #swagger.description = 'Annuler un meeting existant.'
    // #swagger.security = [{ "Bearer": [] }]
    /*  #swagger.parameters['aborted'] = {
                               in: 'body',
                               description: 'Annulation du meeting',
                               schema: { $ref: '#/definitions/Aborted' }
    } */

    const response = await meetingCtrl.AbortedMeeting(req.body.id, req.body.reason)
    res.status(response.status).send(response.data)
});

routerMee.get("/meeting", async (req, res) => {
    // #swagger.tags = ['Meeting']
    // #swagger.description = 'Récupération des meetings.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['includeAborted'] = {
	       in: 'query',
           description: 'Inclure les meetings annulés.',
           type: 'boolean'
    }
   #swagger.parameters['mine'] = {
          in: 'query',
          description: 'Voir uniquement les meetings auxquelles je participe.',
          type: 'boolean'
   }
   #swagger.parameters['town'] = {
          in: 'query',
          description: 'Code INSEE d\'une ville.',
          type: 'string'
   }
   #swagger.parameters['idPoliticalParty'] = {
          in: 'query',
          description: 'L\'id du parti politique',
          type: 'int'
   }
   #swagger.parameters['includeCompleted'] = {
          in: 'query',
          description: 'Inclure les meetings complet',
          type: 'boolean'
   }
   #swagger.parameters['includeFinished'] = {
          in: 'query',
          description: 'Inclure les meetings finis',
          type: 'boolean'
   }
   #swagger.parameters['id'] = {
          in: 'query',
          description: 'L\'id du meeting',
          type: 'number'
   }*/

    const nir = (req.query.mine && req.query.mine === 'true') ? req.data.nir : null
    const response = await meetingCtrl.GetMeeting(req.query.town, req.query.idPoliticalParty, nir, req.query.includeAborted, req.query.includeCompleted, req.query.includeFinished, req.query.id)
    res.status(response.status).send(response.data)
});

routerMee.post("/meeting/participate/:id", async (req, res) => {
    // #swagger.tags = ['Meeting']
    // #swagger.description = 'Participer à un meeting.'
    // #swagger.security = [{ "Bearer": [] }]

    const nir = req.data.nir
    const response = await meetingCtrl.AddParticipant(nir, req.params.id)
    res.status(response.status).send(response.data)
});

routerMee.delete("/meeting/participate/:id", async (req, res) => {
    // #swagger.tags = ['Meeting']
    // #swagger.description = 'Annuler sa participation à un meeting.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['reason'] = {
          in: 'query',
          description: 'La raison de l annulation',
          type: 'string'
   } */

    const nir = req.data.nir
    const response = await meetingCtrl.AbortedParticipant(nir, req.params.id, req.query.reason)
    res.status(response.status).send(response.data)
});

export {routerMee}
