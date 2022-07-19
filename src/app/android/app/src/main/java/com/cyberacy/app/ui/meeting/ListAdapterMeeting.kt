package com.cyberacy.app.ui.meeting

import android.app.Activity
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Meeting
import com.cyberacy.app.ui.meeting.meeting_detail.MeetingDetailActivity

class ListAdapterMeeting(
    val meetings: MutableList<Meeting>,
    val activity: Activity?
) : RecyclerView.Adapter<MeetingViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MeetingViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_meeting, parent, false)
        return MeetingViewHolder(view).listen { pos, _ ->
            val item = meetings[pos]
            val intent = Intent(view?.context, MeetingDetailActivity::class.java)
            intent.putExtra("idMeeting", item.id)
            intent.putExtra("nameMeeting", item.name)
            activity?.startActivity(intent)
        }
    }

    override fun onBindViewHolder(holder: MeetingViewHolder, position: Int) {
        holder.setItem(meetings[position])
    }

    override fun getItemCount(): Int {
        return meetings.size
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}