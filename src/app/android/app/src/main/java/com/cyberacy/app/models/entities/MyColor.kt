package com.cyberacy.app.models.entities

import android.graphics.Color
import com.google.gson.annotations.SerializedName

class MyColor(

    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("red")
    val red: Int,

    @SerializedName("green")
    val green: Int,

    @SerializedName("blue")
    val blue: Int,

    @SerializedName("opacity")
    val opacity: Int,
) {

    fun toColor(): Int {
        return Color.argb(opacity, red, green, blue)
    }

}