import {AddManifestation, AbortedManifestation, GetAllManifestations} from "../controllers/manifestation.controller.mjs";
import express from "express"

const routerMan = express.Router()

routerMan.post("/manifestation", async (req, res) => {
    const response = await AddManifestation(req.body)
    res.status(response.status).send(response.data)
});

routerMan.patch("/manifestation/aborted", async (req, res) => {
    const response = await AbortedManifestation(req.body.id, req.body.reason)
    res.status(response.status).send(response.data)
});

routerMan.get("/manifestation", async (req, res) => {
    const response = await GetAllManifestations(req.query.includeAborted)
    res.status(response.status).send(response.data)
});

routerMan.post("/manifestation/participate", async (req, res) => {

    res.status(response.status).send(response.data)
});

export {routerMan}
