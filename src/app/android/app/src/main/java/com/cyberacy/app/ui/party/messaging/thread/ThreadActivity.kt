package com.cyberacy.app.ui.party.messaging.thread

import android.content.Intent
import android.content.res.Resources
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.activity.viewModels
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.marginEnd
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Connection
import com.cyberacy.app.models.entities.Message
import com.cyberacy.app.models.entities.SendMessage
import com.cyberacy.app.models.entities.Session
import com.cyberacy.app.models.repositories.*
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.navigation.NavigationActivity
import com.facebook.shimmer.ShimmerFrameLayout
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.Dispatchers.Main
import kotlinx.coroutines.delay
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
    private lateinit var layoutMessage: TextInputLayout
    private lateinit var message: TextInputEditText
    private var idThread by Delegates.notNull<Int>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_thread)

        idThread = intent.getIntExtra("idThread", 0)
        val nameThread = intent.getStringExtra("nameThread")
        val logoThread = intent.getStringExtra("logoThread")

        val vm: ThreadViewModel by viewModels { ThreadViewModel.Factory(idThread) }
        viewModel = vm

        loaderMsg = findViewById(R.id.loader_msg)
        loaderSend = findViewById(R.id.loader_send)
        recyclerView = findViewById(R.id.recyclerview)
        labelNoData = findViewById(R.id.label_no_data)
        buttonSend = findViewById(R.id.btn_send)
        layoutMessage = findViewById(R.id.layout_message)
        message = findViewById(R.id.message)

        initMessages()
        buttonSend.setOnClickListener { this.sendMessage() }
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
                        recyclerView.adapter =
                            ListAdapterMessage(it.messages as MutableList<Message>, resources)
                        recyclerView.layoutManager = GridLayoutManager(this, 1)
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

    fun setItem(item: Message, resources: Resources) {
        val mv = 15
        val mh = 100
        if (item.mine) {
            cardMessage.background = resources.getDrawable(R.drawable.message_mine)
            val param = (cardMessage.layoutParams as ViewGroup.MarginLayoutParams).apply {
                setMargins(mh, mv, 0, mv)
            }
            cardMessage.layoutParams = param
        } else {
            cardMessage.background = resources.getDrawable(R.drawable.message_other)
            val param = (cardMessage.layoutParams as ViewGroup.MarginLayoutParams).apply {
                setMargins(0, mv, mh, mv)
            }
            cardMessage.layoutParams = param
        }
        message.text = item.message
        messageUser.text = item.getUserName()
        val formatter: DateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy")
        messageDate.text = formatter.format(item.datePublished)
    }
}