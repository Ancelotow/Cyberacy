package com.cyberacy.app.models.services

import com.cyberacy.app.models.entities.Connection
import com.cyberacy.app.models.entities.PoliticalParty
import com.cyberacy.app.models.entities.Session
import retrofit2.Call
import retrofit2.http.*

interface ApiService {

    @POST("login_app")
    fun login(@Body connection: Connection): Call<String>

    @GET("political_party")
    fun getPoliticalParty(
        @Query("mine") mine: Boolean = false,
        @Query("idPoliticalParty") id: Int? = null,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<List<PoliticalParty>?>

    @POST("political_party/{id}/join")
    fun joinParty(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<String>

    @GET("thread")
    fun getThreads(
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<List<Thread>?>

}