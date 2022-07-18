package com.cyberacy.app.models.entities

import android.content.Context
import com.cyberacy.app.R
import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter

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

    fun getUserName(): String {
        return if (mine) {
            "Moi"
        } else {
            "$lastname $firstname"
        }
    }

    fun getDateMessage(context: Context): String {
        val formatterDate: DateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
        val formatterTime: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
        val today: LocalDate = LocalDateTime.now().atZone(ZoneId.systemDefault()).toLocalDate()
        val dateMessage: LocalDate = datePublished.atZone(ZoneId.systemDefault()).toLocalDate()
        if (today.isEqual(dateMessage)) {
            return context.getString(R.string.txt_message_today, formatterTime.format(datePublished))
        } else if (today.plusDays(-1).isEqual(dateMessage)) {
            return context.getString(R.string.txt_message_yesterday, formatterTime.format(datePublished))
        } else {
            return formatterDate.format(datePublished)
        }
    }

    companion object Service {

        suspend fun getMessages(id: Int): List<Message> {
            try {
                val response: ResponseAPI<List<Message>?> =
                    ApiConnection.connection().getMessages(id).await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}