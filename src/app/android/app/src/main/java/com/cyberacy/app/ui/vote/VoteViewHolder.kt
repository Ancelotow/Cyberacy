package com.cyberacy.app.ui.vote

import android.graphics.Color
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Vote
import java.time.Duration

class VoteViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val voteName = v.findViewById<TextView>(R.id.vote_name)
    private val voteType = v.findViewById<TextView>(R.id.vote_type)
    private val voteCurrentRound = v.findViewById<TextView>(R.id.current_round)
    private val logoTime = v.findViewById<ImageView>(R.id.logo_time)

    fun setItem(item: Vote) {
        voteName.text = item.name
        voteType.text = item.typeName
        val round = item.getCurrentRound()?.name ?: "Tour"
        val durationLeft: Duration = item.getDurationLeft() ?: Duration.ZERO
        voteCurrentRound.text = "$round : ${item.getTimeLeftStr()}"
        if(durationLeft.toMinutes() <= 15) {
            voteCurrentRound.setTextColor(ContextCompat.getColor(itemView.context, R.color.red));
            logoTime.setColorFilter(ContextCompat.getColor(itemView.context, R.color.red), android.graphics.PorterDuff.Mode.SRC_IN)
        } else if(durationLeft.toMinutes() <= 60) {
            voteCurrentRound.setTextColor(ContextCompat.getColor(itemView.context, R.color.orange));
            logoTime.setColorFilter(ContextCompat.getColor(itemView.context, R.color.orange), android.graphics.PorterDuff.Mode.SRC_IN)
        }
    }
}