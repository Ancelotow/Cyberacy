package com.cyberacy.app.models.entities

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.models.services.ApiConnection
import com.google.firebase.ktx.Firebase
import com.google.firebase.messaging.ktx.messaging
import com.google.gson.annotations.SerializedName
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await

class FCMTopic(
    @SerializedName("fcm_topic")
    val fcm_topic: String
) {

    companion object Service {

        fun subscribeAllTopic(activity: AppCompatActivity) {
            Firebase.messaging.subscribeToTopic("all")
            activity.lifecycleScope.launch {
                try {
                    val response = ApiConnection.connection().getAllFCMTopics().await()
                    val listTopics = response.data ?: emptyList()
                    for(topic in listTopics) {
                        Firebase.messaging.subscribeToTopic(topic.fcm_topic)
                    }
                } catch(e: HttpException) {
                    Log.e("Erreur HTTP", e.message())
                }
            }
        }

    }

}