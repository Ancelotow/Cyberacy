package com.cyberacy.app.ui.vote.to_vote

import android.content.res.Configuration
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Choice
import com.cyberacy.app.models.repositories.ChoiceStateError
import com.cyberacy.app.models.repositories.ChoiceStateLoading
import com.cyberacy.app.models.repositories.ChoiceStateSuccess
import com.facebook.shimmer.ShimmerFrameLayout
import com.google.android.material.button.MaterialButton
import kotlin.properties.Delegates

class ToVoteActivity : AppCompatActivity() {

    private lateinit var viewModel: ToVoteViewModel
    private var idVote by Delegates.notNull<Int>()
    private var idRound by Delegates.notNull<Int>()
    private lateinit var nameRound: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_to_vote)
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        idVote = intent.getIntExtra("idVote", 0)
        idRound = intent.getIntExtra("idRound", 0)
        nameRound = intent.getStringExtra("nameRound").toString()
        val vm: ToVoteViewModel by viewModels { ToVoteViewModel.Factory(idVote, idRound) }
        viewModel = vm
        findViewById<TextView>(R.id.title).text = nameRound
        initChoices()
    }

    private fun initChoices() {
        val shimmerLayout = findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = findViewById<RecyclerView>(R.id.recyclerview)
        recyclerView.visibility = View.GONE
        viewModel.listChoice.observe(this) {
            when (it) {
                is ChoiceStateError -> {
                    shimmerLayout.visibility = View.GONE
                }
                ChoiceStateLoading -> {
                    recyclerView.visibility = View.GONE
                    shimmerLayout.visibility = View.VISIBLE
                }
                is ChoiceStateSuccess -> {
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.VISIBLE
                    recyclerView.adapter = ListAdapterChoice(it.choices as MutableList<Choice>, this)
                    recyclerView.layoutManager = GridLayoutManager(baseContext, 1)
                }
                else -> {}
            }
        }
    }
}