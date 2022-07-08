package com.cyberacy.app.ui.party.join_party

import android.app.AlertDialog
import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.PoliticalParty

class ListAdapterParty(
    val parties: MutableList<PoliticalParty>,
    val itemClick: (item: PoliticalParty) -> Unit
) : RecyclerView.Adapter<PartyViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PartyViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_party, parent, false)
        return PartyViewHolder(view).listen { pos, _ ->
            val item = parties[pos]
            itemSelected(item, parent.context)
        }
    }

    override fun onBindViewHolder(holder: PartyViewHolder, position: Int) {
        holder.setItem(parties[position])
    }

    override fun getItemCount(): Int {
        return parties.size
    }

    private fun itemSelected(item: PoliticalParty, context: Context) {
        val alertDialogBuilder = AlertDialog.Builder(context)
        alertDialogBuilder.setTitle(R.string.txt_join_party)
        alertDialogBuilder.setMessage("Êtes-vous sûr(e) de vouloir rejoindre le parti ${item.name} ?")
        alertDialogBuilder.setPositiveButton(R.string.btn_yes) { dialog, which ->
            itemClick.invoke(item)
        }
        alertDialogBuilder.setNegativeButton(R.string.btn_no) { dialog, which ->
            Toast.makeText(context, R.string.txt_join_party_cancel, Toast.LENGTH_SHORT).show()
        }
        alertDialogBuilder.show()
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}