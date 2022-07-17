package com.cyberacy.app.ui.meeting

import android.content.Intent
import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Meeting
import com.cyberacy.app.ui.meeting.meeting_detail.MeetingDetailActivity
import com.cyberacy.app.ui.meeting.meeting_ticket.MeetingTicketActivity
import com.google.android.material.button.MaterialButton

class MeetingViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val meetingMonth = v.findViewById<TextView>(R.id.txt_month)
    private val meetingDay = v.findViewById<TextView>(R.id.txt_day)
    private val meetingName = v.findViewById<TextView>(R.id.txt_name)
    private val meetingPlace = v.findViewById<TextView>(R.id.txt_lieu)
    private val meetingPrice = v.findViewById<TextView>(R.id.txt_price)
    private val btnQrcode = v.findViewById<MaterialButton>(R.id.btn_qrcode)

    fun setItem(item: Meeting) {
        meetingMonth.text = item.getMonthPrefix()
        meetingDay.text = item.dateStart.dayOfMonth.toString()
        meetingName.text = item.name
        meetingPlace.text = item.getPosition()
        meetingPrice.text = itemView.context.getString(R.string.txt_meeting_price, item.getPriceStr())
        if(item.isParticipated) {
            btnQrcode.visibility = View.VISIBLE
            btnQrcode.setOnClickListener {
                val intent = Intent(itemView.context, MeetingTicketActivity::class.java)
                intent.putExtra("idMeeting", item.id)
                itemView.context.startActivity(intent)
            }
        }
    }

}