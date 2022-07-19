import {Authentication, Register} from '../controllers/auth.controller.mjs'
import express from "express"

const routerAuth = express.Router()

routerAuth.post("/register", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Créer un compte basé sur le NIR (numéro de sécurité sociale).'
    // #swagger.produces = ['application/json']
    // #swagger.consumes = ['application/json']
    /*  #swagger.parameters['person'] = {
                   in: 'body',
                   description: 'La nouvelle personne',
                   schema: { $ref: '#/definitions/Person' }
    } */

    const response = await Register(req.body)
    res.status(response.code).send(response)
});

routerAuth.post("/login_app", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Connexion et retourne le Bearer token (pour application Android).'
    // #swagger.produces = ['application/json']
    // #swagger.consumes = ['application/json']
    /*  #swagger.parameters['connection'] = {
                       in: 'body',
                       description: 'Informations de connexion',
                       schema: { $ref: '#/definitions/Connection' }
    } */

    const response = await Authentication(req.body.nir, req.body.password, "APP_ANDROID#CONNECTION")
    res.status(response.code).send(response)
});

routerAuth.post("/login_stats", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Connexion et retourne le Bearer token (pour application de statistiques IOS).'
    // #swagger.produces = ['application/json']
    // #swagger.consumes = ['application/json']
    /*  #swagger.parameters['connection'] = {
                           in: 'body',
                           description: 'Informations de connexion',
                           schema: { $ref: '#/definitions/Connection' }
    } */

    const response = await Authentication(req.body.nir, req.body.password, "APP_IOS#CONNECTION")
    res.status(response.code).send(response)
});

routerAuth.post("/login_bo", async (req, res) => {
    // #swagger.tags = ['Authentification']
    // #swagger.description = 'Connexion et retourne le Bearer token (pour le back-office Flutter).'
    // #swagger.produces = ['application/json']
    // #swagger.consumes = ['application/json']
    /*  #swagger.parameters['connection'] = {
                               in: 'body',
                               description: 'Informations de connexion',
                               schema: { $ref: '#/definitions/Connection' }
    } */

    const response = await Authentication(req.body.nir, req.body.password, "BO#CONNECTION")
    res.status(response.code).send(response)
});


export {routerAuth}
