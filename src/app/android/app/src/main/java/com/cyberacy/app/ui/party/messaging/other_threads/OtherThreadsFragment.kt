package com.cyberacy.app.ui.party.messaging.other_threads

import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.PoliticalParty
import com.cyberacy.app.models.entities.ThreadMessaging
import com.cyberacy.app.models.repositories.ThreadStateError
import com.cyberacy.app.models.repositories.ThreadStateLoading
import com.cyberacy.app.models.repositories.ThreadStateSuccess
import com.cyberacy.app.models.services.ApiConnection
import com.facebook.shimmer.ShimmerFrameLayout
import com.google.firebase.ktx.Firebase
import com.google.firebase.messaging.ktx.messaging
import com.squareup.picasso.Picasso
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await


class OtherThreadsFragment : Fragment() {

    private val viewModel: OtherThreadsViewModel by viewModels()
    private lateinit var loaderJoin: ProgressBar

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
        val labelNoData = view.findViewById<TextView>(R.id.label_no_data)
        loaderJoin = view.findViewById(R.id.loader_join)
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
                    if(it.threads.isEmpty()) {
                        labelNoData.visibility = View.VISIBLE
                    } else {
                        recyclerView.visibility = View.VISIBLE
                        recyclerView.adapter =
                            ListAdapterOtherThread(it.threads as MutableList<ThreadMessaging>) { thread ->
                                threadSelected(thread)
                            }
                        recyclerView.layoutManager = GridLayoutManager(context, 1)
                    }
                }
            }
        }
    }

    private fun threadSelected(thread: ThreadMessaging) {
        loaderJoin.visibility = View.VISIBLE
        activity?.window?.setFlags(
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
        )
        lifecycleScope.launch {
            try {
                ApiConnection.connection().joinThread(thread.id).await()
                Firebase.messaging.subscribeToTopic(thread.fcmTopic)
                activity?.recreate()
            } catch (e: HttpException) {
                Log.e("Erreur HTTP", e.message())
            } finally {
                loaderJoin.visibility = View.GONE
                activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);
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