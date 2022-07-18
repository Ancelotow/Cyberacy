package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await

class Gender(

    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

) {

    override fun toString(): String {
        return name
    }

    companion object Service {

        suspend fun getGenders(): List<Gender> {
            try {
                val response: ResponseAPI<List<Gender>> = ApiConnection.connection().getGenders().await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}