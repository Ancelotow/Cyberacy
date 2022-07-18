package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await

class Department(

    @SerializedName("code")
    val code: String,

    @SerializedName("name")
    val name: String,

    @SerializedName("region_code_insee")
    val regionCodeInsee: String,

    @SerializedName("id_color")
    val id_color: Int?,

){


    companion object Service {

        suspend fun getDepartment(): List<Department> {
            try {
                val response: ResponseAPI<List<Department>> =
                    ApiConnection.connection().getDepartments().await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

    override fun toString(): String {
        return "$code - $name"
    }

}