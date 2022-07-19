package com.cyberacy.app.ui.party.messaging.my_threads

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.ThreadMessaging

class ListAdapterMyThread(
    val threads: MutableList<ThreadMessaging>,
    val threadClick: (item: ThreadMessaging) -> Unit
) : RecyclerView.Adapter<MyThreadViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyThreadViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_mythread, parent, false)
        return MyThreadViewHolder(view).listen { pos, _ ->
            val item = threads[pos]
            itemSelected(item, parent.context)
        }
    }

    override fun onBindViewHolder(holder: MyThreadViewHolder, position: Int) {
        holder.setItem(threads[position])
    }

    override fun getItemCount(): Int {
        return threads.size
    }

    private fun itemSelected(item: ThreadMessaging, context: Context) {
        threadClick.invoke(item)
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}