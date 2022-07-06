package com.cyberacy.app.ui.party.messaging.thread

import android.app.AlertDialog
import android.content.Intent
import android.content.res.Resources
import android.os.Bundle
import android.util.Log
import android.view.*
import android.widget.*
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Message
import com.cyberacy.app.models.entities.SendMessage
import com.cyberacy.app.models.entities.Session
import com.cyberacy.app.models.repositories.*
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.navigation.NavigationActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.squareup.picasso.Picasso
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await
import java.time.format.DateTimeFormatter
import kotlin.properties.Delegates


class ThreadActivity : AppCompatActivity() {

    private lateinit var viewModel: ThreadViewModel
    private lateinit var loaderMsg: ProgressBar
    private lateinit var loaderSend: ProgressBar
    private lateinit var recyclerView: RecyclerView
    private lateinit var labelNoData: TextView
    private lateinit var buttonSend: MaterialButton
    private lateinit var buttonExit: MaterialButton
    private lateinit var layoutMessage: TextInputLayout
    private lateinit var message: TextInputEditText
    private lateinit var nameThread: String
    private lateinit var logoThread: String
    private var idThread by Delegates.notNull<Int>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_thread)

        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()

        idThread = intent.getIntExtra("idThread", 0)
        nameThread = intent.getStringExtra("nameThread").toString()
        logoThread = intent.getStringExtra("logoThread").toString()

        val vm: ThreadViewModel by viewModels { ThreadViewModel.Factory(idThread) }
        viewModel = vm

        loaderMsg = findViewById(R.id.loader_msg)
        loaderSend = findViewById(R.id.loader_send)
        recyclerView = findViewById(R.id.recyclerview)
        labelNoData = findViewById(R.id.label_no_data)
        buttonSend = findViewById(R.id.btn_send)
        buttonExit = findViewById(R.id.btn_exit)
        layoutMessage = findViewById(R.id.layout_message)
        message = findViewById(R.id.message)

        designActionBar()
        initMessages()
        buttonSend.setOnClickListener { this.sendMessage() }
        buttonExit.setOnClickListener { this.leaveThread() }
    }

    fun designActionBar() {
        findViewById<TextView>(R.id.name).text = nameThread
        if(logoThread != null) {
            if(logoThread.isNotEmpty()) {
                Picasso.get().load(logoThread).into(findViewById<ImageView>(R.id.logo))
            }
        }
    }

    fun initMessages() {
        recyclerView.visibility = View.GONE
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
                        val linearLayoutManager = LinearLayoutManager(this)
                        linearLayoutManager.reverseLayout = true
                        linearLayoutManager.stackFromEnd = true
                        recyclerView.layoutManager = linearLayoutManager
                        recyclerView.adapter = ListAdapterMessage(it.messages as MutableList<Message>, resources)
                        recyclerView.scrollToPosition(0)
                    }
                }
            }
        }
    }

    fun sendMessage() {
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
            try{
                ApiConnection.connection().postMessage(idThread, messageToSend).await()
                Toast.makeText(this@ThreadActivity, R.string.txt_message_sent, Toast.LENGTH_SHORT).show()
                this@ThreadActivity.message.text = null
            } finally {
                loaderSend.visibility = View.GONE
                buttonSend.visibility = View.VISIBLE
            }
        }
    }

    fun leaveThread() {
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
                try{
                    ApiConnection.connection().leaveThread(idThread).await()
                    this@ThreadActivity.finish();
                } catch (e: HttpException) {
                    if(e.code() == 401) {
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


class ListAdapterMessage(
    val messages: MutableList<Message>,
    val resources: Resources
) : RecyclerView.Adapter<MessageViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MessageViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val view = inflater.inflate(R.layout.item_message, parent, false)
        return MessageViewHolder(view)
    }

    override fun onBindViewHolder(holder: MessageViewHolder, position: Int) {
        holder.setItem(messages[position], resources)
    }

    override fun getItemCount(): Int {
        return messages.size
    }

}

class MessageViewHolder(v: View) : RecyclerView.ViewHolder(v) {

    private val messageUser = v.findViewById<TextView>(R.id.user)
    private val message = v.findViewById<TextView>(R.id.message)
    private val messageDate = v.findViewById<TextView>(R.id.date_message)
    private val cardMessage = v.findViewById<ConstraintLayout>(R.id.card_message)
    private val layoutMessage = v.findViewById<RelativeLayout>(R.id.layout_message)

    fun setItem(item: Message, resources: Resources) {
        if (item.mine) {
            cardMessage.background = resources.getDrawable(R.drawable.message_mine)
            layoutMessage.gravity = Gravity.RIGHT
        } else {
            cardMessage.background = resources.getDrawable(R.drawable.message_other)
            layoutMessage.gravity = Gravity.LEFT
        }
        message.text = item.message
        messageUser.text = item.getUserName()
        messageDate.text = item.getDateMessage()
    }
}