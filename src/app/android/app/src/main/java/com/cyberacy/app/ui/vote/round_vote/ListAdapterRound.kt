package com.cyberacy.app.ui.vote.round_vote

import android.app.Activity
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.PopUpWindow
import com.cyberacy.app.models.entities.Round
import com.cyberacy.app.ui.vote.to_vote.ToVoteActivity
import java.time.LocalDateTime

class ListAdapterRound(
    val rounds: MutableList<Round>,
    val activity: Activity?,
    private val itemClick: (item: Round) -> Unit
) : RecyclerView.Adapter<RoundViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RoundViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_round, parent, false)
        return RoundViewHolder(view).listen { pos, _ ->
            val item = rounds[pos]
            val today = LocalDateTime.now()
            if(item.dateEnd.isBefore(today)) {
                PopUpWindow(view.context.getString(R.string.txt_round_finished), R.drawable.ic_info, R.id.layout_list_round).showPopUp(activity as AppCompatActivity)
            } else if(item.dateStart.isAfter(today)) {
                PopUpWindow(view.context.getString(R.string.txt_round_not_started), R.drawable.ic_info, R.id.layout_list_round).showPopUp(activity as AppCompatActivity)
            } else if(item.isVoted) {
                PopUpWindow(view.context.getString(R.string.txt_already_voted), R.drawable.ic_success, R.id.layout_list_round).showPopUp(activity as AppCompatActivity)
            } else {
                itemClick.invoke(item)
            }
        }
    }

    override fun onBindViewHolder(holder: RoundViewHolder, position: Int) {
        holder.setItem(rounds[position])
    }

    override fun getItemCount(): Int {
        return rounds.size
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}