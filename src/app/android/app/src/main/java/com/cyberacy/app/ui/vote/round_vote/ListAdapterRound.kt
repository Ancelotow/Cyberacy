package com.cyberacy.app.ui.vote.round_vote

import android.app.Activity
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Round

class ListAdapterRound(
    val rounds: MutableList<Round>,
    val activity: Activity?
) : RecyclerView.Adapter<RoundViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RoundViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_round, parent, false)
        return RoundViewHolder(view).listen { pos, _ ->
            val item = rounds[pos]
            /*val intent = Intent(view?.context, MeetingDetailActivity::class.java)
            intent.putExtra("idMeeting", item.id)
            intent.putExtra("nameMeeting", item.name)
            activity?.startActivity(intent)*/
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