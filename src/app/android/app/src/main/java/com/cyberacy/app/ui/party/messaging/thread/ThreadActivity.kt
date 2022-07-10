package com.cyberacy.app.ui.party.messaging.thread

import android.app.AlertDialog
import android.content.Intent
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.PorterDuff
import android.os.Bundle
import android.util.Log
import android.view.*
import android.widget.*
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Message
import com.cyberacy.app.models.entities.SendMessage
import com.cyberacy.app.models.repositories.*
import com.cyberacy.app.models.services.ApiConnection
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.google.firebase.ktx.Firebase
import com.google.firebase.messaging.ktx.messaging
import com.squareup.picasso.Picasso
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await
import kotlin.properties.Delegates


class ThreadActivity : AppCompatActivity() {

    private lateinit var viewModel: ThreadViewModel
    private lateinit var loaderMsg: ProgressBar
    private lateinit var loaderSend: ProgressBar
    private lateinit var recyclerView: RecyclerView
    private lateinit var labelNoData: TextView
    private lateinit var buttonSend: MaterialButton
    private lateinit var buttonExit: MaterialButton
    private lateinit var buttonBack: MaterialButton
    private lateinit var layoutMessage: TextInputLayout
    private lateinit var message: TextInputEditText
    private lateinit var nameThread: String
    private lateinit var logoThread: String
    private lateinit var fcmTopicThread: String
    private var idThread by Delegates.notNull<Int>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_thread)

        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()

        idThread = intent.getIntExtra("idThread", 0)
        nameThread = intent.getStringExtra("nameThread").toString()
        logoThread = intent.getStringExtra("logoThread").toString()
        fcmTopicThread = intent.getStringExtra("fcmTopicThread").toString()

        val vm: ThreadViewModel by viewModels { ThreadViewModel.Factory(idThread) }
        viewModel = vm

        loaderMsg = findViewById(R.id.loader_msg)
        loaderSend = findViewById(R.id.loader_send)
        recyclerView = findViewById(R.id.recyclerview)
        labelNoData = findViewById(R.id.label_no_data)
        buttonSend = findViewById(R.id.btn_send)
        buttonExit = findViewById(R.id.btn_exit)
        buttonBack = findViewById(R.id.btn_back)
        layoutMessage = findViewById(R.id.layout_message)
        message = findViewById(R.id.message)

        designActionBar()
        initMessages()
        buttonSend.setOnClickListener { this.sendMessage() }
        buttonExit.setOnClickListener { this.leaveThread() }
    }

    private fun designActionBar() {
        findViewById<TextView>(R.id.name).text = nameThread
        if (logoThread != null) {
            if (logoThread.isNotEmpty()) {
                Picasso.get().load(logoThread).into(findViewById<ImageView>(R.id.logo))
            }
        }
        var colorIcon = android.R.color.black
        when (resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
            Configuration.UI_MODE_NIGHT_YES -> {colorIcon = android.R.color.white}
            Configuration.UI_MODE_NIGHT_NO -> {colorIcon = android.R.color.black}
            Configuration.UI_MODE_NIGHT_UNDEFINED -> {colorIcon = android.R.color.black}
        }
        buttonBack.iconTint = ContextCompat.getColorStateList(this, colorIcon)
        buttonBack.setOnClickListener { finish() }

    }

    private fun initMessages() {
        recyclerView.visibility = View.GONE
        val linearLayoutManager = LinearLayoutManager(this)
        linearLayoutManager.reverseLayout = true
        linearLayoutManager.stackFromEnd = true
        recyclerView.layoutManager = linearLayoutManager
        viewModel.messages.observe(this) {
            when (it) {
                is MessageStateError -> {
                    Log.e("error", it.ex.message())
                    loaderMsg.visibility = View.GONE
                }
                MessageStateLoading -> {
                    recyclerView.visibility = View.GONE
                    loaderMsg.visibility = View.VISIBLE
                }
                is MessageStateSuccess -> {
                    loaderMsg.visibility = View.GONE
                    if (it.messages.isEmpty()) {
                        recyclerView.visibility = View.GONE
                        labelNoData.visibility = View.VISIBLE
                    } else {
                        labelNoData.visibility = View.GONE
                        recyclerView.visibility = View.VISIBLE
                        if(it.messages.size != recyclerView.adapter?.itemCount) {
                            recyclerView.adapter = ListAdapterMessage(it.messages as MutableList<Message>, resources)
                            recyclerView.scrollToPosition(0)
                        }
                    }
                }
            }
        }
    }

    private fun sendMessage() {
        layoutMessage.error = null
        val textMessage = this.message.text.toString()

        if (textMessage.isEmpty()) {
            layoutMessage.error = "Le message ne peut pas être nul"
            return
        }

        loaderSend.visibility = View.VISIBLE
        buttonSend.visibility = View.GONE
        lifecycleScope.launch {
            val messageToSend = SendMessage(textMessage)
            try {
                ApiConnection.connection().postMessage(idThread, messageToSend).await()
                Toast.makeText(this@ThreadActivity, R.string.txt_message_sent, Toast.LENGTH_SHORT)
                    .show()
                this@ThreadActivity.message.text = null
            } finally {
                loaderSend.visibility = View.GONE
                buttonSend.visibility = View.VISIBLE
            }
        }
    }

    private fun leaveThread() {
        val alertDialogBuilder = AlertDialog.Builder(this)
        alertDialogBuilder.setTitle(R.string.txt_join_thread)
        alertDialogBuilder.setMessage("Êtes-vous sûr(e) de vouloir quitter cette discussion ?")
        alertDialogBuilder.setPositiveButton(R.string.btn_yes) { dialog, which ->
            lifecycleScope.launch {
                window?.setFlags(
                    WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
                    WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                )
                loaderSend.visibility = View.VISIBLE
                try {
                    ApiConnection.connection().leaveThread(idThread).await()
                    Firebase.messaging.unsubscribeFromTopic(fcmTopicThread)
                    this@ThreadActivity.finish();
                } catch (e: HttpException) {
                    if (e.code() == 401) {
                        Log.e("Erreur 401", e.message())
                    }
                    loaderSend.visibility = View.GONE
                    window?.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE)
                }
            }
        }
        alertDialogBuilder.setNegativeButton(R.string.btn_no) { dialog, which ->
            Toast.makeText(this, R.string.txt_join_party_cancel, Toast.LENGTH_SHORT).show()
        }
        alertDialogBuilder.show()
    }


}