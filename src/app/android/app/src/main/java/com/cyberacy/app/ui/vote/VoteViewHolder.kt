package com.cyberacy.app.ui.vote

import android.content.res.Configuration
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

        val colorTimeLeft: Int = if(durationLeft.toMinutes() <= 0) {
            when (itemView.resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
                Configuration.UI_MODE_NIGHT_YES -> {
                    android.R.color.white
                }
                else -> {
                    android.R.color.black
                }
            }
        } else if(durationLeft.toMinutes() <= 15) {
            R.color.red
        } else if(durationLeft.toMinutes() <= 60) {
            R.color.orange
        } else {
            R.color.success
        }
        voteCurrentRound.setTextColor(ContextCompat.getColor(itemView.context,colorTimeLeft));
        logoTime.setColorFilter(ContextCompat.getColor(itemView.context, colorTimeLeft), android.graphics.PorterDuff.Mode.SRC_IN)

    }
}