package com.cyberacy.app.models.services

import com.cyberacy.app.models.entities.Connection
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface ApiService {

    @POST("login_app")
    fun login(@Body connection: Connection): Call<String>

}