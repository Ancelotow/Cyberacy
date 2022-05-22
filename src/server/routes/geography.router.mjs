import geographyCtrl from "../controllers/geography.controller.mjs";
import express from "express"

const routerGeo = express.Router()

routerGeo.get("/region", async (req, res) => {
    // #swagger.tags = ['Geography']
    // #swagger.description = 'Récupération des régions.'

    const response = await geographyCtrl.GetRegions()
    res.status(response.status).send(response.data)
});

routerGeo.get("/region/:code_insee/department", async (req, res) => {
    // #swagger.tags = ['Geography']
    // #swagger.description = 'Récupération des départements par régions.'

    const response = await geographyCtrl.GetDepartmentByRegion(req.params.code_insee)
    res.status(response.status).send(response.data)
});

routerGeo.get("/department", async (req, res) => {
    // #swagger.tags = ['Geography']
    // #swagger.description = 'Récupération des départements.'

    const response = await geographyCtrl.GetDepartments()
    res.status(response.status).send(response.data)
});

routerGeo.get("/department/:code/town", async (req, res) => {
    // #swagger.tags = ['Geography']
    // #swagger.description = 'Récupération des communes par département.'

    const response = await geographyCtrl.GetTownsByDepartment(req.params.code)
    res.status(response.status).send(response.data)
});

routerGeo.get("/town", async (req, res) => {
    // #swagger.tags = ['Geography']
    // #swagger.description = 'Récupération des communes.'

    const response = await geographyCtrl.GetTowns()
    res.status(response.status).send(response.data)
});

export {routerGeo}
