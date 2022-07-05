package com.cyberacy.app.models.services

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializer
import com.jakewharton.retrofit2.adapter.kotlin.coroutines.CoroutineCallAdapterFactory
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.converter.scalars.ScalarsConverterFactory
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


object ApiConnection {

    fun connection(): ApiService {
        val uri = "https://cyberacy.herokuapp.com/"
        val gson = createGsonBuilder()
        return Retrofit.Builder()
            .baseUrl(uri)
            .addConverterFactory(ScalarsConverterFactory.create())
            .addConverterFactory(GsonConverterFactory.create(gson))
            .addCallAdapterFactory(CoroutineCallAdapterFactory())
            .build()
            .create(ApiService::class.java)
    }

    private fun createGsonBuilder(): Gson {
        val dateDeserializer = JsonDeserializer { json, _, _ ->
            LocalDateTime.parse(
                json.asString,
                DateTimeFormatter.ISO_DATE_TIME
            )
        }
        return GsonBuilder().registerTypeAdapter(LocalDateTime::class.java, dateDeserializer)
            .setLenient()
            .setDateFormat("yyyy-MM-dd'T'HH:mm:ss")
            .create()
    }

}