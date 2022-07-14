package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName
import java.time.LocalDateTime

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
) {}