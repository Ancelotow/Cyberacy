import {Register} from '../controllers/auth.controller.mjs'
import express from "express"

const routerAuth = express.Router()

routerAuth.post("/register", async (req, res) => {
    const response = await Register(req.body)
    res.status(response.status).send(response.data)
});

routerAuth.post("/login", async (req, res) => {
    const response = await Register(req.body)
    res.status(response.status).send(response.data)
});

export {routerAuth}
