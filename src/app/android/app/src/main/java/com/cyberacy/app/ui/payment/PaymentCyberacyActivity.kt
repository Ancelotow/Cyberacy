package com.cyberacy.app.ui.payment

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Payment
import com.cyberacy.app.models.services.ApiConnection
import com.paypal.checkout.PayPalCheckout
import com.paypal.checkout.approve.OnApprove
import com.paypal.checkout.config.CheckoutConfig
import com.paypal.checkout.config.Environment
import com.paypal.checkout.config.SettingsConfig
import com.paypal.checkout.createorder.CreateOrder
import com.paypal.checkout.createorder.CurrencyCode
import com.paypal.checkout.createorder.OrderIntent
import com.paypal.checkout.createorder.UserAction
import com.paypal.checkout.order.Amount
import com.paypal.checkout.order.AppContext
import com.paypal.checkout.order.Order
import com.paypal.checkout.order.PurchaseUnit
import com.paypal.checkout.paymentbutton.PayPalButton
import com.stripe.android.PaymentConfiguration
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await


class PaymentCyberacyActivity : AppCompatActivity() {

    lateinit var paymentSheet: PaymentSheet
    lateinit var customerConfig: PaymentSheet.CustomerConfiguration
    lateinit var paymentIntentClientSecret: String
    val paypalClientKey =
        "AQ04Pvm5ZXr36j7_YmjMMGvRphBNpLkvOq47LlChH0M7QSYClpGKby54NwDmmB8pcJap3mqEN1mTDZ7V"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment_cyberacy)
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        configurePaypal()
    }

    private fun configurePaypal() {
        val buttonPaypal = findViewById<PayPalButton>(R.id.btn_paypal)
        val config = CheckoutConfig(
            application = this.application,
            clientId = paypalClientKey,
            environment = Environment.SANDBOX,
            returnUrl = "com.cyberacy.app://paypalpay",
            currencyCode = CurrencyCode.EUR,
            userAction = UserAction.PAY_NOW,
            settingsConfig = SettingsConfig(
                loggingEnabled = true
            )
        )
        PayPalCheckout.setConfig(config)
        buttonPaypal.setup(
            createOrder =
            CreateOrder { createOrderActions ->
                val order = Order(
                    intent = OrderIntent.CAPTURE,
                    appContext = AppContext(userAction = UserAction.PAY_NOW),
                    purchaseUnitList =
                    listOf(
                        PurchaseUnit(
                            amount = Amount(currencyCode = CurrencyCode.EUR, value = "01.00")
                        )
                    )
                )
                createOrderActions.create(order)
            },
            onApprove =
            OnApprove { approval ->
                approval.orderActions.capture { captureOrderResult ->
                    Log.i("CaptureOrder", "CaptureOrderResult: $captureOrderResult")
                }
            }
        )
    }

    private fun configureStripe() {
        paymentSheet = PaymentSheet(this, ::onPaymentSheetResult)
        lifecycleScope.launch {
            try {
                val paymentInfo = Payment(
                    amountExcl = 1.592,
                    amountIncludingTax = 1.99,
                    rateVAT = 20.00,
                    libelle = "Meeting réservation",
                    isTest = true,
                    email = ""
                )
                val paymentSheet =
                    ApiConnection.connection().paymentSheetStripe(paymentInfo).await()
                paymentIntentClientSecret = paymentSheet.paymentIntent
                customerConfig = PaymentSheet.CustomerConfiguration(
                    paymentSheet.customer,
                    paymentSheet.ephemeralKey
                )
                PaymentConfiguration.init(this@PaymentCyberacyActivity, paymentSheet.publishableKey)
                presentPaymentSheet()
            } catch (e: HttpException) {
                Log.e("Erreur API", e.message())
            }
        }

    }

    fun presentPaymentSheet() {
        val googlePayConfiguration = PaymentSheet.GooglePayConfiguration(
            environment = PaymentSheet.GooglePayConfiguration.Environment.Test,
            countryCode = "FR",
            currencyCode = "EUR"
        )
        paymentSheet.presentWithPaymentIntent(
            paymentIntentClientSecret,
            PaymentSheet.Configuration(
                merchantDisplayName = "Cyberacy",
                googlePay = googlePayConfiguration,
                customer = customerConfig,
                allowsDelayedPaymentMethods = true
            )
        )
    }

    fun onPaymentSheetResult(paymentSheetResult: PaymentSheetResult) {
        when (paymentSheetResult) {
            is PaymentSheetResult.Canceled -> {
                Log.e("Canceled", "ss")
            }
            is PaymentSheetResult.Failed -> {
                Log.e("Error: ${paymentSheetResult.error}", "ss")
            }
            is PaymentSheetResult.Completed -> {
                // Display for example, an order confirmation screen
                Log.e("Completed", "ss")
            }
        }
    }
}