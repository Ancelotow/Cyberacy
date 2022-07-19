import Stripe from 'stripe';
import {Payment} from "../models/payment.mjs"
import {ResponseApi} from "../models/response-api.mjs";

const GetPaymentSheet = (paymentJson) => {
    return new Promise(async (resolve, reject) => {
        if (paymentJson === null) {
            resolve(new ResponseApi().InitMissingParameters())
            return
        }
        let payment = new Payment()
        Object.assign(payment, paymentJson)
        if (payment.vat_rate === null || payment.amount_including_tax === null ) {
            resolve(new ResponseApi().InitMissingParameters())
            return
        } else if (payment.libelle === null || payment.amount_excl === null || payment.email === null ) {
            resolve(new ResponseApi().InitMissingParameters())
            return
        }  else if (payment.amount_including_tax < 1) {
            resolve(new ResponseApi().InitBadRequest("The amount must be above 1 EUR"))
            return
        }

        let vatRate = payment.vat_rate / 100
        let recalculate_amount_excl = payment.amount_excl + (payment.amount_excl * vatRate)
        if(recalculate_amount_excl !== payment.amount_including_tax) {
            resolve(new ResponseApi().InitBadRequest("The amount including associate with VAT not corresponding with excl. tax amount"))
            return
        }

        const secret_key = (payment.is_test) ? process.env.STRIPE_SECRET_KEY_TEST : process.env.STRIPE_SECRET_KEY
        const public_key = (payment.is_test) ? process.env.STRIPE_PUBLIC_KEY_TEST : process.env.STRIPE_PUBLIC_KEY

        const stripe = new Stripe(secret_key, {apiVersion: '2020-08-27'});
        const customer = await stripe.customers.create();
        const ephemeralKey = await stripe.ephemeralKeys.create(
            {customer: customer.id},
            {apiVersion: '2020-08-27'}
        );
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt((payment.amount_including_tax * 100), 10),
            description: payment.libelle,
            receipt_email: payment.email,
            currency: 'eur',
            customer: customer.id,
            automatic_payment_methods: {
                enabled: true
            }
        });
        let data = {
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customer.id,
            publishableKey: public_key
        }
        resolve(new ResponseApi().InitData(data))
    })
}

export default {GetPaymentSheet}
