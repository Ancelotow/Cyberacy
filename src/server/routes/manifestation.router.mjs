import manifestationCtrl from "../controllers/manifestation.controller.mjs";
import express from "express"

const routerMan = express.Router()

routerMan.post("/manifestation", async (req, res) => {
    const response = await manifestationCtrl.AddManifestation(req.body)
    res.status(response.status).send(response.data)
});

routerMan.patch("/manifestation/aborted", async (req, res) => {
    const response = await manifestationCtrl.AbortedManifestation(req.body.id, req.body.reason)
    res.status(response.status).send(response.data)
});

routerMan.get("/manifestation", async (req, res) => {
    const nir = (req.query.mine && req.query.mine === 'true') ? req.data.nir : null
    const response = await manifestationCtrl.GetAllManifestations(req.query.includeAborted, nir)
    res.status(response.status).send(response.data)
});

routerMan.post("/manifestation/participate/:id", async (req, res) => {
    const nir = req.data.nir
    const response = await manifestationCtrl.Participate(nir, req.params.id)
    res.status(response.status).send(response.data)
});

routerMan.post("/manifestation/option", async (req, res) => {
    const response = await manifestationCtrl.AddOption(req.body)
    res.status(response.status).send(response.data)
});

routerMan.get("/manifestation/option/:id", async (req, res) => {
    const response = await manifestationCtrl.GetOptions(req.params.id)
    res.status(response.status).send(response.data)
});

routerMan.delete("/manifestation/option/:id", async (req, res) => {
    const response = await manifestationCtrl.DeleteOption(req.params.id)
    res.status(response.status).send(response.data)
});


export {routerMan}
