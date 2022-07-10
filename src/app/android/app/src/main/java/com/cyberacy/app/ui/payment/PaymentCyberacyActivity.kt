package com.cyberacy.app.ui.payment

import android.content.Intent
import android.content.res.Configuration
import android.os.Bundle
import android.text.method.LinkMovementMethod
import android.util.Log
import android.view.View
import android.widget.CheckBox
import android.widget.TextView
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Payment
import com.cyberacy.app.models.enums.EResultPayment
import com.cyberacy.app.models.services.ApiConnection
import com.google.android.material.button.MaterialButton
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
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
import kotlin.properties.Delegates


class PaymentCyberacyActivity : AppCompatActivity() {

    lateinit var paymentSheet: PaymentSheet
    lateinit var customerConfig: PaymentSheet.CustomerConfiguration
    lateinit var paymentIntentClientSecret: String
    lateinit var libelle: String
    lateinit var btnPay: MaterialButton
    var amountExcl by Delegates.notNull<Double>()
    var amountIncludingTax by Delegates.notNull<Double>()
    var rateVAT by Delegates.notNull<Double>()
    val paypalClientKey =
        "AQ04Pvm5ZXr36j7_YmjMMGvRphBNpLkvOq47LlChH0M7QSYClpGKby54NwDmmB8pcJap3mqEN1mTDZ7V"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment_cyberacy)
        designActionBar()
        initInformation()
        configurePaypal()

    }

    private fun designActionBar() {
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        val buttonBack = findViewById<MaterialButton>(R.id.btn_back)
        var colorIcon = android.R.color.black
        when (resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
            Configuration.UI_MODE_NIGHT_YES -> {
                colorIcon = android.R.color.white
            }
            Configuration.UI_MODE_NIGHT_NO -> {
                colorIcon = android.R.color.black
            }
            Configuration.UI_MODE_NIGHT_UNDEFINED -> {
                colorIcon = android.R.color.black
            }
        }
        buttonBack.iconTint = ContextCompat.getColorStateList(this, colorIcon)
        buttonBack.setOnClickListener { onBackPressed() }
    }

    private fun initInformation() {
        paymentSheet = PaymentSheet(this, ::onPaymentSheetResult)
        amountExcl = intent.getDoubleExtra("amountExcl", 0.00)
        rateVAT = intent.getDoubleExtra("rateVAT", 0.00)
        libelle = intent.getStringExtra("libelle").toString()
        amountIncludingTax = amountExcl + (amountExcl * (rateVAT / 100))
        findViewById<TextView>(R.id.product).text = libelle
        findViewById<TextView>(R.id.total_ht).text = "Total HT : $amountExcl €"
        findViewById<TextView>(R.id.vat_rate).text = "TVA : ${rateVAT}%"
        findViewById<TextView>(R.id.total_ttc).text = "Total TTC : $amountIncludingTax €"
        val textCGV = findViewById<TextView>(R.id.text_cgv)
        textCGV.movementMethod = LinkMovementMethod.getInstance()
        btnPay = findViewById(R.id.btn_pay)
        btnPay.text = "Payer par carte ($amountIncludingTax €)"
        btnPay.setOnClickListener { configureStripe() }
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
                            amount = Amount(
                                currencyCode = CurrencyCode.EUR,
                                value = amountIncludingTax.toString()
                            )
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

    private fun formIsValid(): Boolean {
        val email = findViewById<TextInputEditText>(R.id.email).text
        val layoutEmail = findViewById<TextInputLayout>(R.id.layout_email)
        val checkBox = findViewById<CheckBox>(R.id.cb_cdv)
        layoutEmail.error = null
        checkBox.error = null
        if (email == null || email.isEmpty()) {
            layoutEmail.error = "Ce champ est obligatoire pour envoyer la facture"
            return false
        }

        if (!checkBox.isChecked) {
            checkBox.error = "Vous devez accepté le CGV pour continuer"
            return false
        }
        return true
    }

    private fun configureStripe() {
        if (!formIsValid()) {
            return
        }
        val loader = findViewById<CircularProgressIndicator>(R.id.progress_circular)
        loader.visibility = View.VISIBLE
        btnPay.visibility = View.GONE
        lifecycleScope.launch {
            try {
                val paymentInfo = Payment(
                    amountExcl = amountExcl,
                    amountIncludingTax = amountIncludingTax,
                    rateVAT = rateVAT,
                    libelle = libelle,
                    isTest = true,
                    email = findViewById<TextInputEditText>(R.id.email).text.toString()
                )
                val response = ApiConnection.connection().paymentSheetStripe(paymentInfo).await()
                if(response.data != null) {
                    val responseStripe = response.data
                    paymentIntentClientSecret = responseStripe.paymentIntent
                    customerConfig = PaymentSheet.CustomerConfiguration(
                        responseStripe.customer,
                        responseStripe.ephemeralKey
                    )
                    PaymentConfiguration.init(this@PaymentCyberacyActivity, responseStripe.publishableKey)
                    presentPaymentSheet()
                }
            } catch (e: HttpException) {
                Log.e("Erreur API", e.response().toString())
            } finally {
                loader.visibility = View.GONE
                btnPay.visibility = View.VISIBLE
            }
        }

    }

    private fun presentPaymentSheet() {
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

    private fun onPaymentSheetResult(paymentSheetResult: PaymentSheetResult) {
        val result: EResultPayment = when (paymentSheetResult) {
            is PaymentSheetResult.Canceled -> {
                EResultPayment.CANCELED
            }
            is PaymentSheetResult.Failed -> {
                EResultPayment.FAILED
            }
            is PaymentSheetResult.Completed -> {
                EResultPayment.SUCCESS
            }
        }
        val intent = Intent()
        intent.putExtra("result_payment", result)
        val intentResult = if (result == EResultPayment.CANCELED) RESULT_CANCELED else RESULT_OK
        setResult(intentResult, intent)
        finish()
    }

    override fun onBackPressed() {
        setResult(RESULT_CANCELED, intent)
        finish()
    }
}