package com.cyberacy.app.ui.manifestation

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Manifestation
import com.cyberacy.app.models.entities.Vote
import com.cyberacy.app.models.repositories.*
import com.cyberacy.app.ui.vote.ListAdapterVote
import com.facebook.shimmer.ShimmerFrameLayout
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.squareup.picasso.Picasso
import com.cyberacy.app.models.repositories.ManifestationStateError as ManifestationStateError
import com.cyberacy.app.models.repositories.ManifestationStateLoading as ManifestationStateLoading
import com.cyberacy.app.models.repositories.ManifestationStateSuccess as ManifestationStateSuccess

class ManifestationFragment : Fragment() {

    private val viewModel: ManifestationViewModel by viewModels()
    //private var idAlbum by Delegates.notNull<Int>();

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_manifestation, container, false)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val shimmerLayout = view.findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recyclerview)
        val bodyError = view.findViewById<ConstraintLayout>(R.id.body_error)
        val bodyErrorHost = view.findViewById<ConstraintLayout>(R.id.body_error_host)
        val txtError = bodyError.findViewById<TextView>(R.id.txt_error)

        recyclerView.visibility = View.GONE
        bodyErrorHost.visibility = View.GONE
        bodyError.visibility = View.GONE

        viewModel.manifestation.observe(viewLifecycleOwner) {
            when (it) {
                is ManifestationStateError -> {
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.VISIBLE
                    txtError.text = getString(R.string.txt_error_happening, it.ex.message)
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.GONE

                }
                is ManifestationStateErrorHost -> {
                    bodyErrorHost.visibility = View.VISIBLE
                    bodyError.visibility = View.GONE
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.GONE
                }
                ManifestationStateLoading -> {
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.GONE
                    recyclerView.visibility = View.GONE
                    shimmerLayout.visibility = View.VISIBLE
                }
                is ManifestationStateSuccess -> {
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.GONE
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.VISIBLE
                    recyclerView.adapter = ListAdapterManifestation(it.manifestation as MutableList<Manifestation>, this.activity)
                    recyclerView.layoutManager = GridLayoutManager(context, 1)

                }
                else -> {}
            }
        }

    }

}
