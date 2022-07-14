package com.cyberacy.app.ui.vote

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Vote
import com.cyberacy.app.models.repositories.*
import com.facebook.shimmer.ShimmerFrameLayout

class VoteFragment : Fragment() {

    private val viewModel: VoteViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_vote, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val shimmerLayout = view.findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recyclerview)
        recyclerView.visibility = View.GONE
        viewModel.listVotes.observe(viewLifecycleOwner) {
            when (it) {
                is VoteStateError -> {
                    shimmerLayout.visibility = View.GONE
                }
                VoteStateLoading -> {
                    recyclerView.visibility = View.GONE
                    shimmerLayout.visibility = View.VISIBLE
                }
                is VoteStateSuccess -> {
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.VISIBLE
                    recyclerView.adapter = ListAdapterVote(it.votes as MutableList<Vote>, this.activity)
                    recyclerView.layoutManager = GridLayoutManager(context, 1)
                }
                else -> {}
            }
        }
    }

}