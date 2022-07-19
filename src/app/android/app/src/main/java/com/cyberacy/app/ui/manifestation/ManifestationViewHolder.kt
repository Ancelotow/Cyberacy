package com.cyberacy.app.ui.manifestation

import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Manifestation

class ManifestationViewHolder (v: View) : RecyclerView.ViewHolder(v){

    private val manifestationName = v.findViewById<TextView>(R.id.txt_name)
    private val txtLieu = v.findViewById<TextView>(R.id.txt_lieu)
    private val nbPrsonEstimate = v.findViewById<TextView>(R.id.nb_person_estimate)
    private val manifestationDay = v.findViewById<TextView>(R.id.txt_day)
    private val manifestationMonth = v.findViewById<TextView>(R.id.txt_month)

    fun setItem(item: Manifestation) {
        manifestationName.text = item.name
        txtLieu.text = item.dateCreate.toString()
        nbPrsonEstimate.text = item.personEstimate.toString()
        manifestationDay.text = item.dateStart.dayOfMonth.toString()
        manifestationMonth.text = item.getMonthPrefix()
    }

}