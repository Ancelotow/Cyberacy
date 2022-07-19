package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.models.services.ApiService
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import kotlin.collections.emptyList as emptyList

class Manifestation (
    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String?,

    @SerializedName("date_start")
    val dateStart: LocalDateTime,

    @SerializedName("date_end")
    val dateEnd: LocalDateTime?,

    @SerializedName("is_aborted")
    val aborted: Boolean?,

    @SerializedName("date_create")
    val dateCreate: LocalDateTime,

    @SerializedName("nb_person_estimate")
    val personEstimate: Int?,

    @SerializedName("steps")
    val steps: List<Step>?,


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

    fun getDateManifestion(dateStart: LocalDateTime): LocalDate {
        val formatterDay: DateTimeFormatter = DateTimeFormatter.ofPattern("dd")
        val today: LocalDate = LocalDateTime.now().atZone(ZoneId.systemDefault()).toLocalDate()
        val dateMeeting: LocalDate = this.dateStart.atZone(ZoneId.systemDefault()).toLocalDate()

        return today
    }


    companion object Service {


            suspend fun getManifestation(): List<Manifestation> {
                try {
                    val response: ResponseAPI<List<Manifestation>?> = ApiConnection.connection().getManifestation().await()
                    return response?.data as List<Manifestation>
                } catch (e: HttpException) {
                    throw e
                }
            }

    }
}