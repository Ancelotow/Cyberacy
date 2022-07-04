package com.cyberacy.app.ui.party

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.FragmentContainerView
import androidx.fragment.app.viewModels
import com.cyberacy.app.R
import com.cyberacy.app.models.repositories.PartyStateError
import com.cyberacy.app.models.repositories.PartyStateLoading
import com.cyberacy.app.models.repositories.PartyStateSuccessMine
import com.cyberacy.app.ui.party.join_party.JoinPartyFragment
import com.cyberacy.app.ui.party.main_party.MainPartyFragment
import com.google.android.material.progressindicator.CircularProgressIndicator

class PartyFragment : Fragment() {

    private val viewModel: PartyViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_party, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val loader = view.findViewById<CircularProgressIndicator>(R.id.loader)
        val childView = view.findViewById<FragmentContainerView>(R.id.party_view)
        loader.visibility = View.VISIBLE
        childView.visibility = View.GONE
        viewModel.mineParty.observe(viewLifecycleOwner) {
            when (it) {
                is PartyStateError -> {
                    loader.visibility = View.GONE
                }
                PartyStateLoading -> {
                    childView.visibility = View.GONE
                    loader.visibility = View.VISIBLE
                }
                is PartyStateSuccessMine -> {
                    loader.visibility = View.GONE
                    childView.visibility = View.VISIBLE
                    if(it.party != null) {
                        changeView(MainPartyFragment.newInstance(it.party.id))
                    } else {
                        changeView(JoinPartyFragment())
                    }
                }
                else -> {}
            }
        }
    }

    fun changeView(view: Fragment) {
        childFragmentManager.beginTransaction()
            .replace(R.id.party_view, view)
            .commit()
    }

}