import {Authentication, Register} from '../controllers/auth.controller.mjs'
import express from "express"

const routerAuth = express.Router()

routerAuth.post("/register", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Créer un compte basé sur le NIR (numéro de sécurité sociale).'

    const response = await Register(req.body)
    res.status(response.status).send(response.data)
});

routerAuth.post("/login_app", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Connexion et retourne le Bearer token (pour application Android).'

    const response = await Authentication(req.body.nir, req.body.password, "APP_ANDROID#CONNECTION")
    res.status(response.status).send(response.data)
});

routerAuth.post("/login_stats", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Connexion et retourne le Bearer token (pour application de statistiques IOS).'

    const response = await Authentication(req.body.nir, req.body.password, "APP_IOS#CONNECTION")
    res.status(response.status).send(response.data)
});

routerAuth.post("/login_bo", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Connexion et retourne le Bearer token (pour le back-office Flutter).'

    const response = await Authentication(req.body.nir, req.body.password, "BO#CONNECTION")
    res.status(response.status).send(response.data)
});



export {routerAuth}
