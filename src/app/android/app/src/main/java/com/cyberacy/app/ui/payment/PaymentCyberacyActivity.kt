package com.cyberacy.app.ui.payment

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import com.cyberacy.app.R
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


class PaymentCyberacyActivity : AppCompatActivity() {

    val clientKey =
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
            clientId = clientKey,
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


}