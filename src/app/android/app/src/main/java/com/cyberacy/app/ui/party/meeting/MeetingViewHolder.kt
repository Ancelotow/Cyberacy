package com.cyberacy.app.ui.party.meeting

import android.content.res.Resources
import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Meeting

class MeetingViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val meetingMonth = v.findViewById<TextView>(R.id.txt_month)
    private val meetingDay = v.findViewById<TextView>(R.id.txt_day)
    private val meetingName = v.findViewById<TextView>(R.id.txt_name)
    private val meetingPlace = v.findViewById<TextView>(R.id.txt_lieu)
    private val meetingPrice = v.findViewById<TextView>(R.id.txt_price)

    fun setItem(item: Meeting) {
        meetingMonth.text = item.getMonthPrefix()
        meetingDay.text = item.dateStart.dayOfMonth.toString()
        meetingName.text = item.name
        meetingPlace.text = item.getPlace()
        meetingPrice.text = "Prix : ${item.getPriceStr()}"
    }

}