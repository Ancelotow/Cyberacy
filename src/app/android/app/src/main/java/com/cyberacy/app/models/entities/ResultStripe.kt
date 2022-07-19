package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

class ResultStripe(

    @SerializedName("paymentIntent")
    val paymentIntent: String,

    @SerializedName("ephemeralKey")
    val ephemeralKey: String,

    @SerializedName("customer")
    val customer: String,

    @SerializedName("publishableKey")
    val publishableKey: String,

) {
}