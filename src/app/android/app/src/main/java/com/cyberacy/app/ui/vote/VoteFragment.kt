package com.cyberacy.app.ui.vote

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
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
        val labelNoData = view.findViewById<TextView>(R.id.label_no_data)
        val bodyError = view.findViewById<ConstraintLayout>(R.id.body_error)
        val bodyErrorHost = view.findViewById<ConstraintLayout>(R.id.body_error_host)
        val txtError = bodyError.findViewById<TextView>(R.id.txt_error)

        recyclerView.visibility = View.GONE
        bodyErrorHost.visibility = View.GONE
        bodyError.visibility = View.GONE
        viewModel.listVotes.observe(viewLifecycleOwner) {
            when (it) {
                is VoteStateError -> {
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.VISIBLE
                    txtError.text = getString(R.string.txt_error_happening, it.ex.message())
                    shimmerLayout.visibility = View.GONE
                    labelNoData.visibility = View.GONE
                    recyclerView.visibility = View.GONE
                }
                is VoteStateErrorHost -> {
                    bodyErrorHost.visibility = View.VISIBLE
                    bodyError.visibility = View.GONE
                    shimmerLayout.visibility = View.GONE
                    labelNoData.visibility = View.GONE
                    recyclerView.visibility = View.GONE
                }
                VoteStateLoading -> {
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.GONE
                    recyclerView.visibility = View.GONE
                    shimmerLayout.visibility = View.VISIBLE
                    labelNoData.visibility = View.GONE
                }
                is VoteStateSuccess -> {
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.GONE
                    shimmerLayout.visibility = View.GONE
                    if(it.votes.isEmpty()) {
                        labelNoData.visibility = View.VISIBLE
                    }
                    recyclerView.visibility = View.VISIBLE
                    recyclerView.adapter = ListAdapterVote(it.votes as MutableList<Vote>, this.activity)
                    recyclerView.layoutManager = GridLayoutManager(context, 1)
                }
                else -> {}
            }
        }
    }

}