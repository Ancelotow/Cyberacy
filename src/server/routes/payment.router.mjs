import paymentCtrl from "../controllers/payment.controller.mjs"
import express from "express"

const routerPay = express.Router()

routerPay.post("/payment-sheet", async (req, res) => {
    // #swagger.tags = ['Payment']
    // #swagger.security = [{ "Bearer": [] }]
    // #swagger.description = 'Permet de payer les achats (ex: réservations de meetings)'
    /*  #swagger.parameters['payment'] = {
                                   in: 'body',
                                   description: 'Objet initialisant un nouveau paiement avec Stripe',
                                   schema: { $ref: '#/definitions/InitPayment' }
    } */

    let response = await paymentCtrl.GetPaymentSheet(req.body)
    res.status(response.status).send(response.data)
});

export {routerPay}
