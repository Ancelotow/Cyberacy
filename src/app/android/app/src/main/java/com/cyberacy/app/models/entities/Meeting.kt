package com.cyberacy.app.models.entities

import android.util.Log
import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.LocalDateTime

class Meeting(
    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("object")
    val meetingObject: String,

    @SerializedName("description")
    val description: String,

    @SerializedName("date_start")
    val dateStart: LocalDateTime,

    @SerializedName("nb_time")
    val nbTime: Double,

    @SerializedName("price_excl")
    val priceExcl: Double,

    @SerializedName("vta_rate")
    val rateVTA: Double,

    @SerializedName("is_aborted")
    val isAborted: Boolean,

    @SerializedName("reason_aborted")
    val reasonAborted: Boolean,

    @SerializedName("nb_place")
    val nbPlace: Int,

    @SerializedName("nb_place_vacant")
    val nbPlaceVacant: Int,

    @SerializedName("address_street")
    val addressStreet: String?,

    @SerializedName("link_twitch")
    val linkTwitch: String?,

    @SerializedName("link_youtube")
    val linkYoutube: String?,

    @SerializedName("town_code_insee")
    val townCodeInsee: String?,
    ) {

    fun getMonthPrefix(): String {
        val listMonthPrefix = listOf("JANV", "FEV", "MARS", "AVR", "MAI", "JUIN", "JUIL", "AOÛT", "SEPT", "OCT", "NOV", "DEC")
        return listMonthPrefix[dateStart.monthValue - 1]
    }

    fun getPriceStr(): String {
        return if(priceExcl <= 0.00) {
            "gratuit"
        } else {
            val price = priceExcl + (priceExcl * (rateVTA / 100))
            "$price €"
        }
    }

    fun getPlace(): String {
        return if(addressStreet == null || townCodeInsee == null || addressStreet.isEmpty() || townCodeInsee.isEmpty()) {
            if(linkYoutube != null) {
                "Youtube"
            } else if(linkTwitch != null) {
                "Twitch"
            } else {
                "Inconnu"
            }
        } else {
            addressStreet
        }
    }

    companion object Service {

        suspend fun getMeetings(id: Int): List<Meeting> {
            try {
                return ApiConnection.connection().getMeeting(idPoliticalParty=id, mine=false, includeCompleted=true, includeFinished=true).await() ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}