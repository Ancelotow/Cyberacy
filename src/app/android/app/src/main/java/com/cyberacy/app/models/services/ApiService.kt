package com.cyberacy.app.models.services

import com.cyberacy.app.models.entities.*
import retrofit2.Call
import retrofit2.http.*

interface ApiService {

    @POST("login_app")
    fun login(@Body connection: Connection): Call<ResponseAPI<Person>>

    @GET("political_party")
    fun getPoliticalParty(
        @Query("mine") mine: Boolean = false,
        @Query("idPoliticalParty") id: Int? = null,
        @Query("includeLeft") includeLeft: Boolean = false,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<PoliticalParty>?>>

    @POST("political_party/{id}/join")
    fun joinParty(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<String>>

    @POST("thread/{id}/join")
    fun joinThread(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<String>>

    @GET("thread")
    fun getThreads(
        @Query("onlyMine") onlyMine: Boolean = false,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<ThreadMessaging>?>>

    @GET("thread/{id}/message")
    fun getMessages(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<Message>?>>

    @POST("thread/{id}/message")
    fun postMessage(
        @Path("id") id: Int,
        @Body message: SendMessage,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<String>>

    @DELETE("thread/{id}/left")
    fun leaveThread(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<String>>

    @GET("meeting")
    fun getMeeting(
        @Query("idPoliticalParty") idPoliticalParty: Int? = null,
        @Query("mine") mine: Boolean = true,
        @Query("includeAborted") includeAborted: Boolean = false,
        @Query("includeCompleted") includeCompleted: Boolean = false,
        @Query("includeFinished") includeFinished: Boolean = false,
        @Query("id") id: Int? = null,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<Meeting>?>>

    @GET("meeting/{id}")
    fun getMeetingById(
        @Path("id") id: Int? = null,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<Meeting?>>

    @POST("meeting/participate/{id}")
    fun participateToMeeting(
        @Path("id") id: Int? = null,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<Unit>>

    @POST("payment-sheet")
    fun paymentSheetStripe(
        @Body payment: Payment,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<ResultStripe>>

}