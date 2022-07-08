package com.cyberacy.app.ui.party.meeting.meeting_detail

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.appcompat.app.ActionBar
import com.cyberacy.app.R

class MeetingDetailActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_meeting_detail)

        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
    }

}