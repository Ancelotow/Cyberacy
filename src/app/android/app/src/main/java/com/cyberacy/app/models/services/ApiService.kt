package com.cyberacy.app.models.services

import com.cyberacy.app.models.entities.*
import retrofit2.Call
import retrofit2.http.*

interface ApiService {

    @POST("login_app")
    fun login(@Body connection: Connection): Call<String>

    @GET("political_party")
    fun getPoliticalParty(
        @Query("mine") mine: Boolean = false,
        @Query("idPoliticalParty") id: Int? = null,
        @Query("includeLeft") includeLeft: Boolean = false,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<List<PoliticalParty>?>

    @POST("political_party/{id}/join")
    fun joinParty(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<String>

    @POST("thread/{id}/join")
    fun joinThread(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<String>

    @GET("thread")
    fun getThreads(
        @Query("onlyMine") onlyMine: Boolean = false,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<List<ThreadMessaging>?>

    @GET("thread/{id}/message")
    fun getMessages(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<List<Message>?>

    @POST("thread/{id}/message")
    fun postMessage(
        @Query("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<List<Message>?>

}