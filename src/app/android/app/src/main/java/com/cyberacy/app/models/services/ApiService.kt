package com.cyberacy.app.models.services

import com.cyberacy.app.models.entities.*
import retrofit2.Call
import retrofit2.http.*

interface ApiService {

    @GET("manifestation")
    fun getManifestation(
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<Manifestation>?>>

    @POST("login_app")
    fun login(@Body connection: Connection): Call<ResponseAPI<Person>>

    @GET("political_party")
    fun getPoliticalParty(
        @Query("mine") mine: Boolean = false,
        @Query("idPoliticalParty") id: Int? = null,
        @Query("includeLeft") includeLeft: Boolean = false,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<PoliticalParty>?>>

    @GET("political_party/mine")
    fun getMinePoliticalParty(
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<PoliticalParty>?>

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

    @DELETE("political_party/left")
    fun leaveParty(
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<Unit>>

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

    @GET("meeting/{id}/details")
    fun getMeetingById(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<Meeting?>>

    @POST("meeting/participate/{id}")
    fun participateToMeeting(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<Unit>>

    @GET("meeting/participate/{id}/details-qrcode")
    fun meetingGetInfoQRCode(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<MeetingQrCode?>>

    @POST("payment-sheet")
    fun paymentSheetStripe(
        @Body payment: Payment,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<ResultStripe>>

    @GET("fcm-topics")
    fun getAllFCMTopics(
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<FCMTopic>>>

    @GET("vote/in_progress")
    fun getVoteInProgress(
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<Vote>?>>

    @GET("vote/{id}/round")
    fun getRoundsFromVote(
        @Path("id") id: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<Round>?>>

    @GET("vote/{id_vote}/round/{id_round}/choice")
    fun getChoicesFromRound(
        @Path("id_vote") idVote: Int,
        @Path("id_round") idRound: Int,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<List<Choice>?>>

    @POST("vote/{id_vote}/round/{id_round}")
    fun toVote(
        @Path("id_vote") idVote: Int,
        @Path("id_round") idRound: Int,
        @Body idChoice: ChoiceToVote,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<Unit>>

    @GET("department")
    fun getDepartments(): Call<ResponseAPI<List<Department>>>

    @GET("department/{code}/town")
    fun getTownsFromDepartment(@Path("code") codeDept: String): Call<ResponseAPI<List<Town>>>

    @GET("sex")
    fun getGenders(): Call<ResponseAPI<List<Gender>>>

    @POST("register")
    fun register(@Body person: Person): Call<ResponseAPI<Unit>>

    @POST("thread")
    fun addThread(
        @Body thread: ThreadMessaging,
        @Header("Authorization") jwtToken: String = "Bearer ${Session.getJwtToken()}"
    ): Call<ResponseAPI<Unit>>

}