package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

class ResponseAPI<T>(
    @SerializedName("status")
    val status: String,

    @SerializedName("message")
    val message: String?,

    @SerializedName("code")
    val code: Int,

    @SerializedName("data")
    val data: T?,
) { }