package com.cyberacy.app.ui.meeting

import android.content.res.Configuration
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Meeting
import com.cyberacy.app.models.repositories.*
import com.facebook.shimmer.ShimmerFrameLayout
import com.google.android.material.button.MaterialButton
import kotlin.properties.Delegates

class ListMeetingActivity : AppCompatActivity() {

    private var idParty by Delegates.notNull<Int>()
    private lateinit var viewModel: ListMeetingViewModel


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list_meeting)

        idParty = intent.getIntExtra("idParty", 0)
        val vm: ListMeetingViewModel by viewModels { ListMeetingViewModel.Factory(idParty) }
        viewModel = vm

        designActionBar()
        initMeetings()
    }

    private fun designActionBar() {
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        val buttonBack = findViewById<MaterialButton>(R.id.btn_back)
        var colorIcon = android.R.color.black
        when (resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
            Configuration.UI_MODE_NIGHT_YES -> {colorIcon = android.R.color.white}
            Configuration.UI_MODE_NIGHT_NO -> {colorIcon = android.R.color.black}
            Configuration.UI_MODE_NIGHT_UNDEFINED -> {colorIcon = android.R.color.black}
        }
        buttonBack.iconTint = ContextCompat.getColorStateList(this, colorIcon)
        buttonBack.setOnClickListener { finish() }
    }

    private fun initMeetings() {
        val recyclerView = findViewById<RecyclerView>(R.id.recyclerview)
        val shimmerLayout = findViewById<ShimmerFrameLayout>(R.id.shimmer_layout)
        val labelNoData = findViewById<TextView>(R.id.label_no_data)
        val bodyError = findViewById<ConstraintLayout>(R.id.body_error)
        val bodyErrorHost = findViewById<ConstraintLayout>(R.id.body_error_host)
        val txtError = bodyError.findViewById<TextView>(R.id.txt_error)

        recyclerView.visibility = View.GONE
        bodyErrorHost.visibility = View.GONE
        bodyError.visibility = View.GONE
        val linearLayoutManager = LinearLayoutManager(this)
        linearLayoutManager.reverseLayout = true
        linearLayoutManager.stackFromEnd = true
        recyclerView.layoutManager = linearLayoutManager
        viewModel.listMeetings.observe(this) {
            when (it) {
                is MeetingListStateError -> {
                    Log.e("error", it.ex.message())
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.VISIBLE
                    txtError.text = getString(R.string.txt_error_happening, it.ex.message())
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.GONE
                }
                is MeetingListStateErrorHost -> {
                    bodyErrorHost.visibility = View.VISIBLE
                    bodyError.visibility = View.GONE
                    shimmerLayout.visibility = View.GONE
                    recyclerView.visibility = View.GONE
                }
                MeetingListStateLoading -> {
                    recyclerView.visibility = View.GONE
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.GONE
                    shimmerLayout.visibility = View.VISIBLE
                }
                is MeetingListStateSuccess -> {
                    bodyErrorHost.visibility = View.GONE
                    bodyError.visibility = View.GONE
                    shimmerLayout.visibility = View.GONE
                    if (it.meetings.isEmpty()) {
                        recyclerView.visibility = View.GONE
                        labelNoData.visibility = View.VISIBLE
                    } else {
                        labelNoData.visibility = View.GONE
                        recyclerView.visibility = View.VISIBLE
                        recyclerView.adapter = ListAdapterMeeting(it.meetings as MutableList<Meeting>, this@ListMeetingActivity)
                        recyclerView.scrollToPosition(0)
                    }
                }
                else -> {}
            }
        }
    }


}