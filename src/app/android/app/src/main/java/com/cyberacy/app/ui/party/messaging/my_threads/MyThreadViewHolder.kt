package com.cyberacy.app.ui.party.messaging.my_threads

import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.ThreadMessaging
import com.squareup.picasso.Picasso
import java.time.format.DateTimeFormatter

class MyThreadViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val threadName = v.findViewById<TextView>(R.id.name)
    private val threadDateLastMsg = v.findViewById<TextView>(R.id.date_last_msg)
    private val threadLastMessage = v.findViewById<TextView>(R.id.last_message)
    private val threadLogo = v.findViewById<ImageView>(R.id.logo)

    fun setItem(item: ThreadMessaging) {
        threadName.text = item.name
        val formatter: DateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy")
        if(item.lastMessage == null) {
            threadDateLastMsg.text = formatter.format(item.dateCreate)
        } else {
            threadDateLastMsg.text =  item.lastMessage.getDateMessage()
            threadLastMessage.text = "${item.lastMessage.firstname} : ${item.lastMessage.message}"
        }
        if(item.urlLogo != null) {
            if(item.urlLogo.isNotEmpty()) {
                Picasso.get().load(item.urlLogo).into(threadLogo)
            }
        }
    }
}