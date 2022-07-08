package com.cyberacy.app.ui.party.join_party

import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.PoliticalParty
import com.squareup.picasso.Picasso

class PartyViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val partyName = v.findViewById<TextView>(R.id.party_name)
    private val partyLogo = v.findViewById<ImageView>(R.id.logo)

    fun setItem(item: PoliticalParty) {
        partyName.text = item.name
        Picasso.get().load(item.urlLogo).into(partyLogo)
    }
}