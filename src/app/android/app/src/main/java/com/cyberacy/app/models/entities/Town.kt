package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

class Town(

    @SerializedName("code_insee")
    val codeInsee: String,

    @SerializedName("name")
    val name: String,

    @SerializedName("zip_code")
    val zip_code: String,

    @SerializedName("nb_resident")
    val nbResident: Int,

    @SerializedName("department_code")
    val deptCode: Int,

) {
}