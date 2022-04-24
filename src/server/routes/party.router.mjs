import partyCtrl from "../controllers/party.controller.mjs";
import express from "express"

const routerParty = express.Router()

routerParty.post("/political_party", async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Ajout de un nouveau parti politique si il éxiste dans la BDD de INSEE.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.AddParty(req.body)
    res.status(response.status).send(response.data)
});

routerParty.get("/political_party", async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Récupération des partis politiques.'
    // #swagger.security = [{ "Bearer": [] }]
    /* #swagger.parameters['siren'] = {
	       in: 'query',
           description: 'Recherher par le SIREN.',
           type: 'string'
    } */
    const siren = (req.query.siren == null) ? null : req.query.siren
    const response = await partyCtrl.GetAllParty(siren)
    res.status(response.status).send(response.data)
});

routerParty.post("/political_party/:siren/upload_logo", async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Upload le logo du parti politique.'
    // #swagger.security = [{ "Bearer": [] }]

    try {
        if (!req.files) {
            res.status(400).send("No file upload")
        } else {
            let party = req.files.party;
            party.mv('./uploads/political_party/' + party.siren);
            const datafile = {
                name: party.name,
                mimetype: party.mimetype,
                size: party.size
            }
            res.status(201).send(datafile)
        }
    } catch (err) {
        res.status(500).send(err);
    }
});

export {routerParty}
