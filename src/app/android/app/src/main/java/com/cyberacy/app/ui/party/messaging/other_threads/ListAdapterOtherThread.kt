package com.cyberacy.app.ui.party.messaging.other_threads

import android.app.AlertDialog
import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.ThreadMessaging

class ListAdapterOtherThread(
    val threads: MutableList<ThreadMessaging>,
    val threadClick: (item: ThreadMessaging) -> Unit
) : RecyclerView.Adapter<OtherThreadViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): OtherThreadViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_thread, parent, false)
        return OtherThreadViewHolder(view).listen { pos, _ ->
            val item = threads[pos]
            itemSelected(item, parent.context)
        }
    }

    override fun onBindViewHolder(holder: OtherThreadViewHolder, position: Int) {
        holder.setItem(threads[position])
    }

    override fun getItemCount(): Int {
        return threads.size
    }

    private fun itemSelected(item: ThreadMessaging, context: Context) {
        val alertDialogBuilder = AlertDialog.Builder(context)
        alertDialogBuilder.setTitle(R.string.txt_join_thread)
        alertDialogBuilder.setMessage("Êtes-vous sûr(e) de vouloir rejoindre la discussion \"${item.name}\" ?")
        alertDialogBuilder.setPositiveButton(R.string.btn_yes) { dialog, which ->
            threadClick.invoke(item)
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