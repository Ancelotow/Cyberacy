package com.cyberacy.app.ui.party.messaging

import android.graphics.PorterDuff
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ImageView
import androidx.appcompat.app.ActionBar
import com.cyberacy.app.R

class MessagingActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_messaging)

        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()

        val logoMsg = findViewById<ImageView>(R.id.logo_msg)
        logoMsg.setColorFilter(getResources().getColor(android.R.color.black), PorterDuff.Mode.SRC_IN);

    }

}