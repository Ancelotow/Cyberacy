package com.cyberacy.app.ui.party.messaging.other_threads

import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.ThreadMessaging
import com.squareup.picasso.Picasso

class OtherThreadViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val threadName = v.findViewById<TextView>(R.id.name)
    private val threadLogo = v.findViewById<ImageView>(R.id.logo)

    fun setItem(item: ThreadMessaging) {
        threadName.text = item.name
        if (item.urlLogo != null) {
            if (item.urlLogo.isNotEmpty()) {
                Picasso.get().load(item.urlLogo).into(threadLogo)
            }
        }
    }
}