package com.cyberacy.app.models.entities

import com.cyberacy.app.models.enums.EVoteState
import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class Round(

    @SerializedName("num")
    val num: Int,

    @SerializedName("id_vote")
    val idVote: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("date_start")
    val dateStart: LocalDateTime,

    @SerializedName("date_end")
    val dateEnd: LocalDateTime,

    @SerializedName("is_voted")
    val isVoted: Boolean,

) {

    fun getNumRoundStr(): String {
        return if(num == 1) {
            "1er tour"
        } else if (num == 2) {
            "2nd tour"
        } else {
            "${num}ème tour"
        }
    }

    fun getVoteState(): EVoteState {
        val today = LocalDateTime.now()
        return if(!isVoted && dateEnd.isBefore(today)) {
            EVoteState.ABSTAINED
        } else if (!isVoted) {
            EVoteState.TO_VOTE
        } else {
            EVoteState.VOTED
        }
    }

    fun getDurationLeft(): Duration {
        return Duration.between(LocalDateTime.now(), this.dateEnd)
    }

    fun getTimeLeftStr(): String {
        if(LocalDateTime.now().isBefore(this.dateStart)) {
            val formatterDate: DateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
            return "Commence le ${formatterDate.format(dateStart)}"
        }
        val duration = getDurationLeft()
        if(duration.isNegative || duration.isZero) {
            return "Terminé"
        } else if(duration.toHoursPart() <= 0) {
            return "Se termine dans ${duration.toMinutes()} minutes"
        }
        val nbMinutes = (duration.toMinutes() - (duration.toHoursPart() * 60)).toInt()
        return "Se termine dans ${duration.toHoursPart()}h${nbMinutes.toString().padStart(2, '0')}min"
    }

    companion object Service {

        suspend fun getRounds(idVote: Int): List<Round> {
            try {
                val response: ResponseAPI<List<Round>?> =
                    ApiConnection.connection().getRoundsFromVote(idVote).await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}