package com.cyberacy.app.ui.vote.to_vote

import android.app.Activity
import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.core.view.get
import androidx.core.view.size
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Choice

class ListAdapterChoice(
    private val choices: MutableList<Choice>,
    val activity: Activity?,
    private val itemClick: (item: Choice) -> Unit
) : RecyclerView.Adapter<ChoiceViewHolder>() {

    var indexSelected = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ChoiceViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_choice, parent, false)
        return ChoiceViewHolder(view).listen { pos, _ ->
            val item = choices[pos]
            indexSelected = pos
            for(i in 0 until parent.size) {
                val color = if(i == indexSelected) ContextCompat.getColor(view.context, R.color.success) else Color.TRANSPARENT
                parent[i].findViewById<ConstraintLayout>(R.id.layout_item_choice).setBackgroundColor(color)
            }
            itemClick.invoke(item)
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
