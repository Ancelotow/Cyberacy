package com.cyberacy.app.ui.party.join_party

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.RecyclerView.ViewHolder
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.PoliticalParty
import com.cyberacy.app.models.entities.Session
import com.cyberacy.app.models.repositories.*
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.navigation.NavigationActivity
import com.cyberacy.app.ui.party.PartyFragment
import com.cyberacy.app.ui.party.main_party.MainPartyFragment
import com.facebook.shimmer.ShimmerFrameLayout
import com.squareup.picasso.Picasso
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await

class JoinPartyFragment : Fragment() {

    private val viewModel: JoinPartyViewModel by viewModels()
    private lateinit var loaderJoin: ProgressBar

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_join_party, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val shimmer_layout = view.findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recyclerview)
        loaderJoin = view.findViewById(R.id.loader_join)
        recyclerView.visibility = View.GONE
        viewModel.listParty.observe(viewLifecycleOwner) {
            when (it) {
                is PartyStateError -> {
                    shimmer_layout.visibility = View.GONE
                }
                PartyStateLoading -> {
                    recyclerView.visibility = View.GONE
                    shimmer_layout.visibility = View.VISIBLE
                }
                is PartyStateSuccessList -> {
                    shimmer_layout.visibility = View.GONE
                    recyclerView.visibility = View.VISIBLE
                    recyclerView.adapter =
                        ListAdapterParty(it.parties as MutableList<PoliticalParty>) { party ->
                            partySelected(party)
                        }
                    recyclerView.layoutManager = GridLayoutManager(context, 1)
                }
                else -> {}
            }
        }
    }

    private fun partySelected(party: PoliticalParty) {
        loaderJoin.visibility = View.VISIBLE
        activity?.window?.setFlags(
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
        )
        lifecycleScope.launch {
            try {
                ApiConnection.connection().joinParty(party.id).await()
                (parentFragment!! as PartyFragment).refresh()
            } catch (e: HttpException) {
                Log.e("Erreur HTTP", e.message())
            } finally {
                loaderJoin.visibility = View.GONE
                activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);
            }
        }
    }

}