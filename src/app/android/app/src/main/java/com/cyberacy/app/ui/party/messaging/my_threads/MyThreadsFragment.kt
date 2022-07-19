package com.cyberacy.app.ui.party.messaging.my_threads

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
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
import com.cyberacy.app.ui.party.messaging.thread.ThreadActivity
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
        initMyThread()
    }

    fun initMyThread() {
        val shimmer_layout = view?.findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = view?.findViewById<RecyclerView>(R.id.recyclerview)
        val labelNoData = view?.findViewById<TextView>(R.id.label_no_data)
        recyclerView?.visibility = View.GONE
        viewModel.myThreads.observe(viewLifecycleOwner) {
            when (it) {
                is ThreadStateError -> {
                    shimmer_layout?.visibility = View.GONE
                }
                is ThreadStateErrorHost -> {
                    shimmer_layout?.visibility = View.GONE
                }
                ThreadStateLoading -> {
                    recyclerView?.visibility = View.GONE
                    shimmer_layout?.visibility = View.VISIBLE
                }
                is ThreadStateSuccess -> {
                    shimmer_layout?.visibility = View.GONE
                    if(it.threads.isEmpty()) {
                        labelNoData?.visibility = View.VISIBLE
                    } else {
                        recyclerView?.visibility = View.VISIBLE
                        recyclerView?.adapter =
                            ListAdapterMyThread(it.threads as MutableList<ThreadMessaging>) { thread ->
                                val intent = Intent(view?.context, ThreadActivity::class.java)
                                intent.putExtra("idThread",thread.id)
                                intent.putExtra("nameThread",thread.name)
                                intent.putExtra("logoThread",thread.urlLogo)
                                intent.putExtra("fcmTopicThread",thread.fcmTopic)
                                startActivity(intent)
                            }
                        recyclerView?.layoutManager = GridLayoutManager(context, 1)
                    }
                }
            }
        }
    }

}