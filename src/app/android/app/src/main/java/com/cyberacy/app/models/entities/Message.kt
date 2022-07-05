package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.LocalDateTime

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
    val datePublished: LocalDateTime,

    @SerializedName("mine")
    val mine: Boolean
) {

    fun getUserName(): String{
        return if(mine) {
            "Moi"
        } else {
            "$lastname $firstname"
        }
    }

    companion object Service {

        suspend fun getMessages(id: Int): List<Message> {
            try {
                return ApiConnection.connection().getMessages(id).await() ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}