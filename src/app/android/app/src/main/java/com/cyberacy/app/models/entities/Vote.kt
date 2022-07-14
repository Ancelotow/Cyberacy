package com.cyberacy.app.models.entities

import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import com.google.type.Date
import com.google.type.DateTime
import retrofit2.HttpException
import retrofit2.await
import java.time.Duration
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.Period

class Vote(

    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("nb_voter")
    val nbVoter: Int,

    @SerializedName("town_code_insee")
    val townCodeInsee: String,

    @SerializedName("department_code")
    val departementCode: String,

    @SerializedName("reg_code_insee")
    val regCodeInsee: String,

    @SerializedName("id_political_party")
    val idPoliticalParty: Int,

    @SerializedName("id_type")
    val idType: Int,

    @SerializedName("name_type")
    val typeName: String,

    @SerializedName("id_election")
    val idElection: Int,

    @SerializedName("rounds")
    val rounds: List<Round>,

) {

    fun getCurrentRound(): Round? {
        if(rounds.isEmpty()) {
            return null;
        }
        val today = LocalDateTime.now()
        return rounds.find { rnd -> rnd.dateStart.isBefore(today) && rnd.dateEnd.isAfter(today) }
    }

    fun getDurationLeft(): Duration? {
        val round = getCurrentRound() ?: return null
        return Duration.between(LocalDateTime.now(), round.dateEnd)
    }

    fun getTimeLeftStr(): String {
        val duration = getDurationLeft() ?: return "Terminé"
        if(duration.toHoursPart() <= 0) {
            return "Se termine dans ${duration.toMinutes()} minutes"
        }
        val nbMinutes = (duration.toMinutes() - (duration.toHoursPart() * 60)).toInt()
        return "Se termine dans ${duration.toHoursPart()}h${nbMinutes}min"
    }

    companion object Service {

        suspend fun getVoteInProgress(): List<Vote> {
            try {
                val response: ResponseAPI<List<Vote>?> =
                    ApiConnection.connection().getVoteInProgress().await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}