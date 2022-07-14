package com.cyberacy.app.models.entities

import android.graphics.Color
import com.cyberacy.app.R
import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import retrofit2.HttpException
import retrofit2.await

class Choice(

    @SerializedName("id")
    val id: Int,

    @SerializedName("name")
    val name: String,

    @SerializedName("id_vote")
    val idVote: Int,

    @SerializedName("description")
    val description: String,

    @SerializedName("candidat_nir")
    val candidateNIR: String?,

    @SerializedName("candidat")
    val candidate: String?,

    @SerializedName("id_color")
    val idColor: Int?,

    @SerializedName("color")
    val color: MyColor?,

) {

    fun getColorChoice(): Int {
        return color?.toColor() ?: Color.argb(255, 200, 200, 200)
    }

    companion object Service {

        suspend fun getChoices(idVote: Int, idRound: Int): List<Choice> {
            try {
                val response: ResponseAPI<List<Choice>?> =
                    ApiConnection.connection().getChoicesFromRound(idVote, idRound).await()
                return response.data ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}