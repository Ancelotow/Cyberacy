package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.LocalDateTime

class MeetingQrCode(

    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("date_start")
    val dateStart: LocalDateTime,

    @SerializedName("uuid")
    val uuid: String,

    @SerializedName("firstname")
    val firstname: String,

    @SerializedName("lastname")
    val lastname: String,

    @SerializedName("birthday")
    val birthday: LocalDateTime,

    @SerializedName("civility")
    val civility: String,

    ) {

    companion object Service {

        suspend fun getMeetingsQRCode(id: Int): MeetingQrCode? {
            try {
                val response: ResponseAPI<MeetingQrCode?> = ApiConnection.connection().meetingGetInfoQRCode(id).await()
                return response.data
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}