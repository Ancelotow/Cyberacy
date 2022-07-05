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

class ListAdapterParty(
    val parties: MutableList<PoliticalParty>,
    val itemClick: (item: PoliticalParty) -> Unit
) : RecyclerView.Adapter<PartyViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PartyViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_party, parent, false)
        return PartyViewHolder(view).listen { pos, _ ->
            val item = parties[pos]
            itemSelected(item, parent.context)
        }
    }

    override fun onBindViewHolder(holder: PartyViewHolder, position: Int) {
        holder.setItem(parties[position])
    }

    override fun getItemCount(): Int {
        return parties.size
    }

    private fun itemSelected(item: PoliticalParty, context: Context) {
        val alertDialogBuilder = AlertDialog.Builder(context)
        alertDialogBuilder.setTitle(R.string.txt_join_party)
        alertDialogBuilder.setMessage("Êtes-vous sûr(e) de vouloir rejoindre le parti ${item.name} ?")
        alertDialogBuilder.setPositiveButton(R.string.btn_yes) { dialog, which ->
            itemClick.invoke(item)
        }
        alertDialogBuilder.setNegativeButton(R.string.btn_no) { dialog, which ->
            Toast.makeText(context, R.string.txt_join_party_cancel, Toast.LENGTH_SHORT).show()
        }
        alertDialogBuilder.show()
    }

    // Listener quand on clique sur l'élément
    private fun <T : ViewHolder> T.listen(event: (position: Int, type: Int) -> Unit): T {
        itemView.setOnClickListener {
            event.invoke(adapterPosition, itemViewType)
        }
        return this
    }

}


class PartyViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val partyName = v.findViewById<TextView>(R.id.party_name)
    private val partyLogo = v.findViewById<ImageView>(R.id.logo)

    fun setItem(item: PoliticalParty) {
        partyName.text = item.name
        Picasso.get().load(item.urlLogo).into(partyLogo)
    }
}