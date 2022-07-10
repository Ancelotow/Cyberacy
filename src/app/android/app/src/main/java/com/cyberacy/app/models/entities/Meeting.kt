package com.cyberacy.app.models.entities

import android.util.Log
import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter

class Meeting(
    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("object")
    val meetingObject: String,

    @SerializedName("description")
    val description: String?,

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

    @SerializedName("latitude")
    val latitude: Double?,

    @SerializedName("longitude")
    val longitude: Double?,

    @SerializedName("is_participate")
    val isParticipated: Boolean = false,

    @SerializedName("town_name")
    val townName: String?,

    @SerializedName("town")
    val town: Town?,
) {

    fun getMonthPrefix(): String {
        val listMonthPrefix = listOf(
            "JANV",
            "FEV",
            "MARS",
            "AVR",
            "MAI",
            "JUIN",
            "JUIL",
            "AOÛT",
            "SEPT",
            "OCT",
            "NOV",
            "DEC"
        )
        return listMonthPrefix[dateStart.monthValue - 1]
    }

    fun getPriceStr(): String {
        return if (priceExcl <= 0.00) {
            "gratuit"
        } else {
            val price = priceExcl + (priceExcl * (rateVTA / 100))
            "$price €"
        }
    }

    fun getPosition(): String {
        return if (addressStreet == null || townCodeInsee == null || addressStreet.isEmpty() || townCodeInsee.isEmpty()) {
            if (linkYoutube != null) {
                "Youtube"
            } else if (linkTwitch != null) {
                "Twitch"
            } else {
                "Inconnu"
            }
        } else {
            addressStreet
        }
    }

    fun getNbPlaceStr(): String {
        return if(nbPlaceVacant < 0) {
            "Illimité"
        } else if(nbPlaceVacant == 0) {
            "Complet"
        } else if(nbPlaceVacant in 1..10) {
            "Plus que $nbPlaceVacant places"
        } else {
            "$nbPlaceVacant places restantes"
        }
    }

    fun getAddressFull(): String {
        var addressFull = addressStreet ?: ""
        if(town != null) {
            addressFull += ", ${town.zip_code} ${town.name}"
        }
        return addressFull
    }

    fun getDateMeeting(): String{
        val formatterDate: DateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
        val formatterTime: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
        val today: LocalDate = LocalDateTime.now().atZone(ZoneId.systemDefault()).toLocalDate()
        val dateMeeting: LocalDate = dateStart.atZone(ZoneId.systemDefault()).toLocalDate()
        return if(today.isEqual(dateMeeting)) {
            "Aujourd'hui à ${formatterTime.format(dateStart)}"
        } else {
            formatterDate.format(dateStart)
        }
    }

    fun getTimeStr(): String{
        if(nbTime <= 0) {
            return "Indéterminée"
        }
        val nbTotalMinutes = nbTime * 60
        val nbHour = nbTime.toInt()
        val nbMinutes = (nbTotalMinutes - (nbHour * 60)).toInt()
        return "${nbHour}h$nbMinutes"
    }

    fun getTimeEnd(): LocalDateTime{
        return dateStart.plusMinutes((nbTime * 60).toLong())
    }

    fun getDescriptionStr(): String{
        return description ?: "Aucune description"
    }

    fun reservationIsAvailable(): Boolean {
        return (dateStart > LocalDateTime.now() && nbPlaceVacant != 0)
    }

    companion object Service {

        suspend fun getMeetings(partyId: Int): List<Meeting> {
            try {
                val response: ResponseAPI<List<Meeting>?> = ApiConnection.connection().getMeeting(
                    idPoliticalParty = partyId,
                    mine = false,
                    includeCompleted = true,
                    includeFinished = true
                ).await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

        suspend fun getMeetingById(id: Int): Meeting? {
            try {
                val response: ResponseAPI<Meeting?> = ApiConnection.connection().getMeetingById(id).await()
                return response.data
            } catch (e: HttpException) {
                throw e
            }
        }

        suspend fun participatedToMeeting(id: Int): Unit {
            try {
                val response: ResponseAPI<Unit> = ApiConnection.connection().participateToMeeting(id).await()
                return
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}