import voteCtrl from "../controllers/vote.controller.mjs";
import express from "express"

const routerVote = express.Router()

routerVote.post("/vote", async (req, res) => {
    // #swagger.tags = ['Vote']
    // #swagger.description = 'Ajout de un nouveau vote.'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await voteCtrl.AddVote(req.body)
    res.status(response.status).send(response.data)
});

export {routerVote}
