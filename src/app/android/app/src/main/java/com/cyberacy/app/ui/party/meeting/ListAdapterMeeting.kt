package com.cyberacy.app.ui.party.meeting

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Meeting

class ListAdapterMeeting(
    val meetings: MutableList<Meeting>
) : RecyclerView.Adapter<MeetingViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MeetingViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_meeting, parent, false)
        return MeetingViewHolder(view)
    }

    override fun onBindViewHolder(holder: MeetingViewHolder, position: Int) {
        holder.setItem(meetings[position])
    }

    override fun getItemCount(): Int {
        return meetings.size
    }

}