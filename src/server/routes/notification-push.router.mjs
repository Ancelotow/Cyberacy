import express from "express"
import notificationCtrl from "../controllers/notification-push.controller.mjs";

const routerNotifs = express.Router()

routerNotifs.get("/fcm-topics", async (req, res) => {
    // #swagger.tags = ['Notification PUSH']
    // #swagger.description = 'Récupère tout les topics FCM (Notification PUSH) de l\'utilisateur'
    // #swagger.security = [{ "Bearer": [] }]

    const response = await notificationCtrl.GetFCMTopic(req.data.nir)
    res.status(response.code).send(response)
});

export {routerNotifs}
