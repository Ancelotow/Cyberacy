import express from "express"
import Stripe from 'stripe';

const stripe = new Stripe('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', {
    apiVersion: '2020-08-27',
});

const routerPay = express.Router()

routerPay.post("/payment-sheet", async (req, res) => {
    // #swagger.tags = ['Payment']
    // #swagger.description = 'Permet de payer les achats (ex: réservations de meetings)'

    const customer = await stripe.customers.create();
    const ephemeralKey = await stripe.ephemeralKeys.create(
        {customer: customer.id},
        {apiVersion: '2020-08-27'}
    );
    const paymentIntent = await stripe.paymentIntents.create({
        amount: 1099,
        currency: 'eur',
        customer: customer.id,
        automatic_payment_methods: {
            enabled: true
        }
    });
    res.json({
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customer.id,
        publishableKey: 'pk_live_51LJZeoCEvCgdWwGd6AYzj0CeDlnUthpaCusE4gwf8W94mAkJpepSAp5HeBxUs5BSjLheR63fUuPevTVB7zcULiqj00fZPrKbht'
    })
});

export {routerPay}
