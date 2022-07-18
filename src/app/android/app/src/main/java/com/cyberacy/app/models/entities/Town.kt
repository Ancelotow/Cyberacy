package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await

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

    override fun toString(): String {
        return "$name ($zip_code)"
    }

    companion object Service {

        suspend fun getTownsFromDept(codeDept: String): List<Town> {
            try {
                val response: ResponseAPI<List<Town>> =
                    ApiConnection.connection().getTownsFromDepartment(codeDept).await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}