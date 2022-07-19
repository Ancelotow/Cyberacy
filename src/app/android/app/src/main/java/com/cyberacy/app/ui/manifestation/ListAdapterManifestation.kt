package com.cyberacy.app.ui.manifestation

import android.app.Activity
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Manifestation
import com.cyberacy.app.models.entities.Vote
import com.cyberacy.app.ui.vote.VoteViewHolder
import com.cyberacy.app.ui.vote.round_vote.RoundActivity

class ListAdapterManifestation(
    val manifestation: MutableList<Manifestation>,
    val activity: Activity?
) : RecyclerView.Adapter<ManifestationViewHolder>(){


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ManifestationViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_manifestation, parent, false)
        return ManifestationViewHolder(view).listen { pos, _ ->
            val item = manifestation[pos]
            val intent = Intent(view?.context, RoundActivity::class.java)
            intent.putExtra("idVote", item.id)
            intent.putExtra("nameVote", item.name)
            activity?.startActivity(intent)
        }
    }

    override fun onBindViewHolder(holder: ManifestationViewHolder, position: Int) {
        holder.setItem(manifestation[position])
    }

    override fun getItemCount(): Int {
        return manifestation.size
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}