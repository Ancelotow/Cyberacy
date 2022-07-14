package com.cyberacy.app.ui.vote.round_vote

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
import com.cyberacy.app.models.entities.Round
import com.cyberacy.app.models.repositories.*
import com.facebook.shimmer.ShimmerFrameLayout
import com.google.android.material.button.MaterialButton
import kotlin.properties.Delegates

class RoundActivity : AppCompatActivity() {

    private lateinit var viewModel: RoundViewModel
    private var idVote by Delegates.notNull<Int>()
    private lateinit var nameVote: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_round)
        idVote = intent.getIntExtra("idVote", 0)
        nameVote = intent.getStringExtra("nameVote").toString()
        val vm: RoundViewModel by viewModels { RoundViewModel.Factory(idVote) }
        viewModel = vm
        designActionBar()
        initRounds()
    }

    private fun initRounds() {
        val shimmerLayout = findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val recyclerView = findViewById<RecyclerView>(R.id.recyclerview)
        recyclerView.visibility = View.GONE
        viewModel.listRounds.observe(this) {
            when (it) {
                is RoundStateError -> {
                    shimmerLayout.visibility = View.GONE
                }
                RoundStateLoading -> {
                    recyclerView.visibility = View.GONE
                    shimmerLayout.visibility = View.VISIBLE
                }
                is RoundStateSuccess -> {
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.VISIBLE
                    recyclerView.adapter = ListAdapterRound(it.rounds as MutableList<Round>, this)
                    recyclerView.layoutManager = GridLayoutManager(baseContext, 1)
                }
                else -> {}
            }
        }
    }

    private fun designActionBar() {
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        val buttonBack = findViewById<MaterialButton>(R.id.btn_back)
        findViewById<TextView>(R.id.title).text = nameVote
        var colorIcon = android.R.color.black
        colorIcon = when (resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
            Configuration.UI_MODE_NIGHT_YES -> {
                android.R.color.white
            }
            else -> {
                android.R.color.black
            }
        }
        buttonBack.iconTint = ContextCompat.getColorStateList(this, colorIcon)
        buttonBack.setOnClickListener { finish() }
    }

}