package com.cyberacy.app.ui.vote

import android.app.Activity
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Vote
import com.cyberacy.app.ui.vote.round_vote.RoundActivity

class ListAdapterVote(
    val votes: MutableList<Vote>,
    val activity: Activity?
) : RecyclerView.Adapter<VoteViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VoteViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_vote, parent, false)
        return VoteViewHolder(view).listen { pos, _ ->
            val item = votes[pos]
            val intent = Intent(view?.context, RoundActivity::class.java)
            intent.putExtra("idVote", item.id)
            intent.putExtra("nameVote", item.name)
            activity?.startActivity(intent)
        }
    }

    override fun onBindViewHolder(holder: VoteViewHolder, position: Int) {
        holder.setItem(votes[position])
    }

    override fun getItemCount(): Int {
        return votes.size
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}