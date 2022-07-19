package com.cyberacy.app.models.entities

import com.google.gson.annotations.SerializedName

data class ChoiceToVote(
    @SerializedName("id_choice")
    val idChoice: Int
)