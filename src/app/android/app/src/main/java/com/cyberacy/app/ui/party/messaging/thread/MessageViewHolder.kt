package com.cyberacy.app.ui.party.messaging.thread

import android.content.res.Resources
import android.view.Gravity
import android.view.View
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Message

class MessageViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val messageUser = v.findViewById<TextView>(R.id.user)
    private val message = v.findViewById<TextView>(R.id.message)
    private val messageDate = v.findViewById<TextView>(R.id.date_message)
    private val cardMessage = v.findViewById<ConstraintLayout>(R.id.card_message)
    private val layoutMessage = v.findViewById<RelativeLayout>(R.id.layout_message)

    fun setItem(item: Message, resources: Resources) {
        if (item.mine) {
            cardMessage.background = resources.getDrawable(R.drawable.message_mine)
            layoutMessage.gravity = Gravity.RIGHT
        } else {
            cardMessage.background = resources.getDrawable(R.drawable.message_other)
            layoutMessage.gravity = Gravity.LEFT
        }
        message.text = item.message
        messageUser.text = item.getUserName()
        messageDate.text = item.getDateMessage()
    }
}