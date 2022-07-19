package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

class Payment(
    @SerializedName("amount_including_tax")
    val amountIncludingTax: Double,

    @SerializedName("amount_excl")
    val amountExcl: Double,

    @SerializedName("vat_rate")
    val rateVAT: Double,

    @SerializedName("is_test")
    val isTest: Boolean = true,

    @SerializedName("libelle")
    val libelle: String,

    @SerializedName("email")
    val email: String,
) {
}