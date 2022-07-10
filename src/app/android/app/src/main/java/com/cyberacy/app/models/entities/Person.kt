package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

class Person(
    @SerializedName("nir")
    val nir: String,

    @SerializedName("firstname")
    val firstname: String,

    @SerializedName("lastname")
    val lastname: String,

    @SerializedName("email")
    val email: String,

    @SerializedName("birthday")
    val birthday: String,

    @SerializedName("address_street")
    val address_street: String,

    @SerializedName("town")
    val town: String,

    @SerializedName("sex")
    val sex: Int,

    @SerializedName("profile")
    val profile: Int,

    @SerializedName("token")
    val token: String,
) { }