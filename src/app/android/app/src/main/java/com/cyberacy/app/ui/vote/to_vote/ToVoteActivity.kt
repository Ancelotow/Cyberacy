package com.cyberacy.app.ui.vote.to_vote

import android.app.AlertDialog
import android.content.Intent
import android.content.res.Configuration
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.*
import com.cyberacy.app.models.enums.EResultPayment
import com.cyberacy.app.models.repositories.ChoiceStateError
import com.cyberacy.app.models.repositories.ChoiceStateLoading
import com.cyberacy.app.models.repositories.ChoiceStateSuccess
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.navigation.NavigationActivity
import com.facebook.shimmer.ShimmerFrameLayout
import com.google.android.material.button.MaterialButton
import com.google.android.material.progressindicator.CircularProgressIndicator
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await
import kotlin.properties.Delegates

class ToVoteActivity : AppCompatActivity() {

    private lateinit var viewModel: ToVoteViewModel
    private var idVote by Delegates.notNull<Int>()
    private var idRound by Delegates.notNull<Int>()
    private lateinit var nameRound: String
    private var choiceSelected: Choice? = null

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
        findViewById<MaterialButton>(R.id.btn_to_vote).setOnClickListener { confirmToVote() }
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
                    recyclerView.adapter = ListAdapterChoice(it.choices as MutableList<Choice>, this) { choice ->
                        choiceSelected = choice
                    }
                    recyclerView.layoutManager = GridLayoutManager(baseContext, 1)
                }
                else -> {}
            }
        }
    }

    private fun confirmToVote() {
        if(choiceSelected == null) {
            PopUpWindow(getString(R.string.txt_no_choice_selected), R.drawable.ic_warning, R.id.layout_list_choice).showPopUp(this as AppCompatActivity)
            return
        }
        val alertDialogBuilder = AlertDialog.Builder(this)
        alertDialogBuilder.setTitle(R.string.txt_to_vote_confirmation)
        alertDialogBuilder.setMessage(getString(R.string.txt_confirm_choice, choiceSelected!!.name))
        alertDialogBuilder.setPositiveButton(R.string.btn_yes) { dialog, which ->
            toVote()
        }
        alertDialogBuilder.setNegativeButton(R.string.btn_no) { dialog, which ->
            Toast.makeText(this, R.string.txt_join_party_cancel, Toast.LENGTH_SHORT).show()
        }
        alertDialogBuilder.show()
    }

    private fun toVote() {
        val btnVote = findViewById<MaterialButton>(R.id.btn_to_vote)
        val circularProgress = findViewById<CircularProgressIndicator>(R.id.progress_circular)

        circularProgress.visibility = View.VISIBLE
        btnVote.visibility = View.GONE
        lifecycleScope.launch {
            try{
                val choiceToVote = ChoiceToVote(choiceSelected!!.id)
                ApiConnection.connection().toVote(idVote, idRound, choiceToVote).await()
                setResult(RESULT_OK, intent)
                finish()
            } catch (e: HttpException) {
                Log.e("Erreur to vote", e.message())
                PopUpWindow(getString(R.string.txt_error_happening, e.message()), R.drawable.ic_error, R.id.layout_list_choice).showPopUp(this@ToVoteActivity as AppCompatActivity)
            } finally {
                circularProgress.visibility = View.GONE
                btnVote.visibility = View.VISIBLE
            }
        }
    }

    override fun onBackPressed() {
        setResult(RESULT_CANCELED, intent)
        finish()
    }

}