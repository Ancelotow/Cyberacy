package com.cyberacy.app.ui.vote.round_vote

import android.content.res.Configuration
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Round
import com.cyberacy.app.models.enums.EVoteState
import java.time.Duration
import java.time.LocalDateTime

class RoundViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val roundName = v.findViewById<TextView>(R.id.round_name)
    private val roundNum = v.findViewById<TextView>(R.id.round_num)
    private val roundLeftTime = v.findViewById<TextView>(R.id.round_left_time)
    private val logoTime = v.findViewById<ImageView>(R.id.logo_time)
    private val logoIsVote = v.findViewById<ImageView>(R.id.logo_is_vote)
    private val txtIsVote = v.findViewById<TextView>(R.id.txt_is_vote)

    fun setItem(item: Round) {
        roundName.text = item.name
        roundNum.text = item.getNumRoundStr()
        val durationLeft: Duration = item.getDurationLeft() ?: Duration.ZERO
        roundLeftTime.text = item.getTimeLeftStr()

        val colorTimeLeft: Int = if(durationLeft.toMinutes() <= 0 || LocalDateTime.now().isBefore(item.dateStart)) {
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
        roundLeftTime.setTextColor(ContextCompat.getColor(itemView.context,colorTimeLeft));
        logoTime.setColorFilter(ContextCompat.getColor(itemView.context, colorTimeLeft), android.graphics.PorterDuff.Mode.SRC_IN)

        val colorStateVote: Int
        val textStateVote: String
        val iconStateVote: Int
        when(item.getVoteState()) {
            EVoteState.TO_VOTE -> {
                colorStateVote = R.color.orange
                iconStateVote = R.drawable.ic_warning
                textStateVote = "A voter"
            }
            EVoteState.VOTED -> {
                colorStateVote = R.color.success
                iconStateVote = R.drawable.ic_success
                textStateVote = "J'ai voté !"
            }
            else -> {
                colorStateVote = R.color.red
                iconStateVote = R.drawable.ic_canceled
                textStateVote = "Abstenu"
            }
        }
        txtIsVote.setTextColor(ContextCompat.getColor(itemView.context,colorStateVote))
        txtIsVote.text = textStateVote
        logoIsVote.setColorFilter(ContextCompat.getColor(itemView.context, colorStateVote), android.graphics.PorterDuff.Mode.SRC_IN)
        logoIsVote.setImageResource(iconStateVote)
    }
}