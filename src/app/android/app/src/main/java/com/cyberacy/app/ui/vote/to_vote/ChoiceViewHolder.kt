package com.cyberacy.app.ui.vote.to_vote

import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Choice

class ChoiceViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val choiceText = v.findViewById<TextView>(R.id.choice_text)
    private val choiceDesc = v.findViewById<TextView>(R.id.choice_desc)
    private val choiceColor = v.findViewById<ImageView>(R.id.color_choice)

    fun setItem(item: Choice) {
        choiceText.text = item.name
        choiceDesc.text = item.description
        choiceColor.setBackgroundColor(item.getColorChoice())
    }

}