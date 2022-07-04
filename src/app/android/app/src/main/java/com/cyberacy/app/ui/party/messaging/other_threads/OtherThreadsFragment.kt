package com.cyberacy.app.ui.party.messaging.other_threads

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.ThreadMessaging
import com.cyberacy.app.models.repositories.ThreadStateError
import com.cyberacy.app.models.repositories.ThreadStateLoading
import com.cyberacy.app.models.repositories.ThreadStateSuccess
import com.facebook.shimmer.ShimmerFrameLayout
import com.squareup.picasso.Picasso


class OtherThreadsFragment : Fragment() {

    private val viewModel: OtherThreadsViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_other_threads, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val shimmer_layout = view.findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recyclerview)
        recyclerView.visibility = View.GONE
        viewModel.otherThreads.observe(viewLifecycleOwner) {
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
                    recyclerView.visibility = View.VISIBLE
                    recyclerView.adapter =
                        ListAdapterOtherThread(it.threads as MutableList<ThreadMessaging>) { thread ->

                        }
                    recyclerView.layoutManager = GridLayoutManager(context, 1)
                }
            }
        }
    }

}

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

class OtherThreadViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val threadName = v.findViewById<TextView>(R.id.name)
    private val threadLogo = v.findViewById<ImageView>(R.id.logo)

    fun setItem(item: ThreadMessaging) {
        threadName.text = item.name
        if(item.urlLogo != null) {
            if(item.urlLogo.isNotEmpty()) {
                Picasso.get().load(item.urlLogo).into(threadLogo)
            }
        }
    }
}