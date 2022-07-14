package com.cyberacy.app.ui.vote.to_vote

import android.app.Activity
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Choice

class ListAdapterChoice(
    val choices: MutableList<Choice>,
    val activity: Activity?
) : RecyclerView.Adapter<ChoiceViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ChoiceViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_choice, parent, false)
        return ChoiceViewHolder(view).listen { pos, _ ->
            val item = choices[pos]
        }
    }

    override fun onBindViewHolder(holder: ChoiceViewHolder, position: Int) {
        holder.setItem(choices[position])
    }

    override fun getItemCount(): Int {
        return choices.size
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }
}
