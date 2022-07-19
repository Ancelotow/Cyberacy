package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

class Step (
    @SerializedName("id")
    val id: Int,

    @SerializedName("address_street")
    val addressStreet: String?,

    @SerializedName("town_code_insee")
    val townCodeInsee: String?,

    @SerializedName("town_zip_code")
    val townZipCode: String?,

    @SerializedName("town_name")
    val townName: String?,

    @SerializedName("id_manifestation")
    val idManifestation: Int,

    @SerializedName("longitude")
    val longitude: String?,

    @SerializedName("latitude")
    val latitude: String?,

    @SerializedName("id_step_type")
    val idStepType: Int,

    @SerializedName("date_arrived")
    val date_arrived: String?

) {

}