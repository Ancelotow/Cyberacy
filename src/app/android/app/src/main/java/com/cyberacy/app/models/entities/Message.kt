package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

class Message(
    @SerializedName("id")
    val id: Int,

    @SerializedName("firstname")
    val firstname: String,

    @SerializedName("lastname")
    val lastname: String,

    @SerializedName("message")
    val message: String,

    @SerializedName("date_published")
    val datePublished: String
)