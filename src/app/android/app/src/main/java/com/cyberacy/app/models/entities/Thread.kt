package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.lang.Thread

class Thread(
    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("description")
    val description: String,

    @SerializedName("is_private")
    val isPrivate: Boolean
) {

    companion object Service {

        suspend fun getAllThreads(): List<Thread> {
            try {
                return ApiConnection.connection().getThreads().await() ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}