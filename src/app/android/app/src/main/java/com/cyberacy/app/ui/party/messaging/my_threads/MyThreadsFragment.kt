package com.cyberacy.app.ui.party.messaging.my_threads

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.ThreadMessaging
import com.cyberacy.app.models.repositories.*
import com.facebook.shimmer.ShimmerFrameLayout
import com.squareup.picasso.Picasso
import java.time.format.DateTimeFormatter

class MyThreadsFragment : Fragment() {

    private val viewModel: MyThreadViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_my_threads, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val shimmer_layout = view.findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recyclerview)
        val labelNoData = view.findViewById<TextView>(R.id.label_no_data)
        recyclerView.visibility = View.GONE
        viewModel.myThreads.observe(viewLifecycleOwner) {
            when (it) {
                is ThreadStateError -> {
                    shimmer_layout.visibility = View.GONE
                }
                ThreadStateLoading -> {
                    recyclerView.visibility = View.GONE
                    shimmer_layout.visibility = View.VISIBLE
                }
                is ThreadStateSuccess -> {
                    shimmer_layout.visibility = View.GONE
                    if(it.threads.isEmpty()) {
                        labelNoData.visibility = View.VISIBLE
                    } else {
                        recyclerView.visibility = View.VISIBLE
                        recyclerView.adapter =
                            ListAdapterMyThread(it.threads as MutableList<ThreadMessaging>) { thread ->

                            }
                        recyclerView.layoutManager = GridLayoutManager(context, 1)
                    }
                }
            }
        }
    }

}


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
        print("coucou !")
    }

    // Listener quand on clique sur l'élément
    private fun <T : RecyclerView.ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}

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
            threadDateLastMsg.text =  formatter.format(item.lastMessage.datePublished)
            threadLastMessage.text = "${item.lastMessage.firstname} : ${item.lastMessage.message}"
        }
        if(item.urlLogo != null) {
            if(item.urlLogo.isNotEmpty()) {
                Picasso.get().load(item.urlLogo).into(threadLogo)
            }
        }
    }
}