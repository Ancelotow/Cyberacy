package com.cyberacy.app.models.entities

import android.util.Log
import com.cyberacy.app.models.services.ApiConnection
import com.google.gson.annotations.SerializedName
import com.google.type.DateTime
import retrofit2.HttpException
import retrofit2.await

class PoliticalParty(
    @SerializedName("id")
    val id: Int = -1,

    @SerializedName("name")
    val name: String,

    @SerializedName("url_logo")
    val urlLogo: String?,

    @SerializedName("date_create")
    val dateCreate: String,

    @SerializedName("siren")
    val siren: String
) {

    companion object Service {

        suspend fun getPoliticalParties(): List<PoliticalParty> {
            try {
                return ApiConnection.connection().getPoliticalParty().await() ?: emptyList()
            } catch (e: HttpException) {
                throw e
            }
        }

        suspend fun getMinePoliticalParty(): PoliticalParty? {
            try{
                val result = ApiConnection.connection().getPoliticalParty(true).await() ?: emptyList()
                if(result.isEmpty()) {
                    return null
                }
                return result[0]
            } catch (e: HttpException) {
                throw e
            }
        }

        suspend fun getPoliticalPartyById(id: Int): PoliticalParty? {
            try{
                val result = ApiConnection.connection().getPoliticalParty(false, id).await() ?: emptyList()
                if(result.isEmpty()) {
                    return null
                }
                return result[0]
            } catch (e: HttpException) {
                throw e
            }
        }

    }

}