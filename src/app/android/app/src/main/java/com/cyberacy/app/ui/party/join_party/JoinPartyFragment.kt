package com.cyberacy.app.ui.party.join_party

import android.os.Bundle
import android.util.Log
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
import com.cyberacy.app.models.entities.PoliticalParty
import com.cyberacy.app.models.repositories.*
import com.facebook.shimmer.ShimmerFrameLayout
import com.squareup.picasso.Picasso


class JoinPartyFragment : Fragment() {

    private val viewModel: JoinPartyViewModel by viewModels()

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
        shimmer_layout.visibility = View.VISIBLE
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
                    recyclerView.adapter = ListAdapterParty(it.parties as MutableList<PoliticalParty>)
                    recyclerView.layoutManager = GridLayoutManager(context, 1)
                }
                else -> {}
            }
        }
    }

}

class ListAdapterParty(val parties: MutableList<PoliticalParty>) : RecyclerView.Adapter<PartyViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PartyViewHolder {
        return PartyViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_party, parent, false)
        )
    }

    override fun onBindViewHolder(holder: PartyViewHolder, position: Int) {
        holder.setItem(parties[position], (position + 1))
    }

    override fun getItemCount(): Int {
        return parties.size
    }

}


class PartyViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val partyName = v.findViewById<TextView>(R.id.party_name)
    private val partyLogo = v.findViewById<ImageView>(R.id.logo)

    fun setItem(item: PoliticalParty, rank: Int) {
        partyName.text = item.name
        Picasso.get().load(item.urlLogo).into(partyLogo)
    }
}