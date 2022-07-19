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
import com.cyberacy.app.models.repositories.ThreadStateErrorHost
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
                is ThreadStateErrorHost -> {
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