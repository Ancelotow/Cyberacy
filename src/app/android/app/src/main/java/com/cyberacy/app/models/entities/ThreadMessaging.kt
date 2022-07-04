package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await

class ThreadMessaging(
    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("description")
    val description: String,

    @SerializedName("url_logo")
    val urlLogo: String,

    @SerializedName("is_private")
    val isPrivate: Boolean,

    @SerializedName("last_message")
    val lastMessage: Message?
) {

    companion object Service {

        suspend fun getMyThreads(): List<ThreadMessaging> {
            try {
                return ApiConnection.connection().getThreads(onlyMine = true).await() ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

        suspend fun getOtherThreads(): List<ThreadMessaging> {
            try {
                return ApiConnection.connection().getThreads(onlyMine = false).await() ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}