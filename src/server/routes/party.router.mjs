import partyCtrl from "../controllers/party.controller.mjs";
import express from "express"
import {createUpload} from "../middlewares/upload-file.mjs";

const routerParty = express.Router()
const upload = createUpload()

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
    /* #swagger.parameters['mine'] = {
	       in: 'query',
           description: 'Recherher les partie auxquel on a adhéré.',
           type: 'boolean'
    } */
    /* #swagger.parameters['includeLeft'] = {
	       in: 'query',
           description: 'Inclure les partis que l'on a quitté.',
           type: 'string'
    } */
    /* #swagger.parameters['idPoliticalParty'] = {
	       in: 'query',
           description: 'L'id du parti politique recherché.',
           type: 'string'
    } */

    const siren = (req.query.siren == null) ? null : req.query.siren
    const nir = (req.query.mine && req.query.mine === 'true') ? req.data.nir : null
    const includeLeft = (req.query.includeLeft == null || req.query.includeLeft === 'true')
    const idPoliticalParty = (req.query.idPoliticalParty == null) ? null : req.query.idPoliticalParty
    const response = await partyCtrl.GetPoliticalParty(siren, nir, includeLeft, idPoliticalParty)
    res.status(response.status).send(response.data)
});

routerParty.post("/political_party/:id/join", async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Adhérer à un parti politique.'
    // #swagger.security = [{ "Bearer": [] }]

    const nir = req.data.nir
    const response = await partyCtrl.JoinParty(nir, req.params.id)
    res.status(response.status).send(response.data)
});

routerParty.delete("/political_party/left", async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = "Partir d'un parti politique."
    // #swagger.security = [{ "Bearer": [] }]

    const nir = req.data.nir
    const response = await partyCtrl.LeftParty(nir)
    res.status(response.status).send(response.data)
});

routerParty.post("/political_party/annual_fee", async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Ajoute une cotisation annuelle.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.AddAnnualFee(req.body)
    res.status(response.status).send(response.data)
});

routerParty.get("/political_party/:id/annual_fee", async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Récupère les cotisations annuelles d'un parti politique.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.GetAnnualFeeByParty(req.params.id)
    res.status(response.status).send(response.data)
});

routerParty.post("/political_party/:id/upload_logo",  upload.single('logo'), async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Upload le logo du parti politique.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.UploadLogo(req.file, req.params.id)
    res.status(response.status).send(response.data)
});

routerParty.post("/political_party/:id/upload_chart",  upload.single('chart'), async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Upload la charte du parti politique.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.UploadChart(req.file, req.params.id)
    res.status(response.status).send(response.data)
});

routerParty.post("/political_party/:id/upload_bank_details",  upload.single('bank_details'), async (req, res) => {
    // #swagger.tags = ['Political party']
    // #swagger.description = 'Upload les détails bancaires du parti politique.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await partyCtrl.UploadChart(req.file, req.params.id)
    res.status(response.status).send(response.data)
});

export {routerParty}
