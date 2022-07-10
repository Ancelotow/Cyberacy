package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.LocalDateTime

class ThreadMessaging(
    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("description")
    val description: String,

    @SerializedName("url_logo")
    val urlLogo: String,

    @SerializedName("date_create")
    val dateCreate: LocalDateTime,

    @SerializedName("is_private")
    val isPrivate: Boolean,

    @SerializedName("lastMessage")
    val lastMessage: Message?,

    @SerializedName("fcm_topic")
    val fcmTopic: String
) {

    companion object Service {

        suspend fun getMyThreads(): List<ThreadMessaging> {
            try {
                val response: ResponseAPI<List<ThreadMessaging>?> =
                    ApiConnection.connection().getThreads(onlyMine = true).await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

        suspend fun getOtherThreads(): List<ThreadMessaging> {
            try {
                val response: ResponseAPI<List<ThreadMessaging>?> =
                    ApiConnection.connection().getThreads(onlyMine = false).await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}