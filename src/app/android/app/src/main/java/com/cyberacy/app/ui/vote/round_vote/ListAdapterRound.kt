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
    val activity: Activity?
) : RecyclerView.Adapter<RoundViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RoundViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_round, parent, false)
        return RoundViewHolder(view).listen { pos, _ ->
            val item = rounds[pos]
            val today = LocalDateTime.now()
            if(item.dateEnd.isBefore(today)) {
                PopUpWindow("Ce tour est terminé", R.drawable.ic_info, R.id.layout_list_round).showPopUp(activity as AppCompatActivity)
            } else if(item.dateStart.isAfter(today)) {
                PopUpWindow("Ce tour n'as pas encore commencé", R.drawable.ic_info, R.id.layout_list_round).showPopUp(activity as AppCompatActivity)
            } else if(item.isVoted) {
                PopUpWindow("Vous avez déjà voté ", R.drawable.ic_success, R.id.layout_list_round).showPopUp(activity as AppCompatActivity)
            } else {
                val intent = Intent(view?.context, ToVoteActivity::class.java)
                intent.putExtra("idVote", item.idVote)
                intent.putExtra("idRound", item.num)
                intent.putExtra("nameRound", item.name)
                activity?.startActivity(intent)
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