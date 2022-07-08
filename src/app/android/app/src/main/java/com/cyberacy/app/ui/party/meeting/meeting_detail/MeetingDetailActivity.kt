package com.cyberacy.app.ui.party.meeting.meeting_detail

import android.content.Intent
import android.content.res.Configuration
import android.net.Uri
import android.os.Bundle
import android.provider.CalendarContract
import android.util.Log
import android.view.View
import android.widget.ProgressBar
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.widget.NestedScrollView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Meeting
import com.cyberacy.app.models.repositories.*
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import com.google.android.material.button.MaterialButton
import java.time.ZoneOffset
import java.util.*
import kotlin.properties.Delegates


class MeetingDetailActivity : AppCompatActivity() {

    private lateinit var viewModel: MeetingDetailViewModel
    private var idMeeting by Delegates.notNull<Int>()
    private lateinit var nameMeeting: String
    private var meeting: Meeting? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_meeting_detail)
        idMeeting = intent.getIntExtra("idMeeting", 0)
        nameMeeting = intent.getStringExtra("nameMeeting").toString()
        val vm: MeetingDetailViewModel by viewModels { MeetingDetailViewModel.Factory(idMeeting) }
        viewModel = vm
        designActionBar()
        initMeeting()

    }

    private fun initMeeting() {
        val loader = findViewById<ProgressBar>(R.id.loader)
        val body = findViewById<NestedScrollView>(R.id.body_meeting)
        val textNoData = findViewById<TextView>(R.id.text_no_date)
        loader.visibility = View.VISIBLE
        body.visibility = View.GONE
        textNoData.visibility = View.GONE
        viewModel.meeting.observe(this) {
            when (it) {
                is MeetingStateError -> {
                    Log.e("error", it.ex.message())
                    loader.visibility = View.GONE
                    textNoData.visibility = View.VISIBLE
                    textNoData.text = "Une erreur est survenue...\n${it.ex.message()}"
                }
                MeetingStateLoading -> {
                    body.visibility = View.GONE
                    loader.visibility = View.VISIBLE
                }
                is MeetingStateSuccessById -> {
                    loader.visibility = View.GONE
                    if (it.meeting == null) {
                        textNoData.visibility = View.VISIBLE
                    } else {
                        body.visibility = View.VISIBLE
                        this@MeetingDetailActivity.meeting = it.meeting
                        initInformation()
                        initGoogleMaps()
                    }
                }
                else -> {}
            }
        }
    }

    private fun designActionBar() {
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        val buttonBack = findViewById<MaterialButton>(R.id.btn_back)
        findViewById<TextView>(R.id.title).text = nameMeeting
        var colorIcon = android.R.color.black
        when (resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
            Configuration.UI_MODE_NIGHT_YES -> {
                colorIcon = android.R.color.white
            }
            Configuration.UI_MODE_NIGHT_NO -> {
                colorIcon = android.R.color.black
            }
            Configuration.UI_MODE_NIGHT_UNDEFINED -> {
                colorIcon = android.R.color.black
            }
        }
        buttonBack.iconTint = ContextCompat.getColorStateList(this, colorIcon)
        buttonBack.setOnClickListener { finish() }

    }

    private fun initInformation() {
        if (meeting != null) {
            findViewById<TextView>(R.id.nb_place).text = meeting!!.getNbPlaceStr()
            findViewById<TextView>(R.id.position).text = meeting!!.getPosition()
            findViewById<TextView>(R.id.price).text = "Prix : ${meeting!!.getPriceStr()}"
            findViewById<TextView>(R.id.date).text = meeting!!.getDateMeeting()
            findViewById<TextView>(R.id.time).text = "Durée : ${meeting!!.getTimeStr()}"
            findViewById<TextView>(R.id.description).text = meeting!!.getDescriptionStr()

            val btnTwitch = findViewById<MaterialButton>(R.id.btn_twitch)
            val btnYoutube = findViewById<MaterialButton>(R.id.btn_youtube)
            val btnPaypal = findViewById<MaterialButton>(R.id.btn_paypal)
            val btnGoogleCalendar = findViewById<MaterialButton>(R.id.btn_google_calendar)

            btnTwitch.visibility = if (meeting!!.linkTwitch == null) View.GONE else View.VISIBLE
            btnYoutube.visibility = if (meeting!!.linkYoutube == null) View.GONE else View.VISIBLE
            btnPaypal.visibility =
                if (meeting!!.reservationIsAvailable()) View.VISIBLE else View.GONE

            btnGoogleCalendar.setOnClickListener { openGoogleCalendar() }
            btnTwitch.setOnClickListener { openTwitch() }
            btnYoutube.setOnClickListener { openYoutube() }
        }
    }

    private fun openTwitch() {
        val twitchIntent: Intent = Uri.parse(meeting!!.linkTwitch).let { webpage ->
            Intent(Intent.ACTION_VIEW, webpage)
        }
        startActivity(twitchIntent)
    }

    private fun openYoutube() {
        val youtubeIntent: Intent = Uri.parse(meeting!!.linkYoutube).let { webpage ->
            Intent(Intent.ACTION_VIEW, webpage)
        }
        startActivity(youtubeIntent)
    }

    private fun openGoogleCalendar() {
        if (meeting != null) {
            val intent = Intent(Intent.ACTION_EDIT)
            intent.type = "vnd.android.cursor.item/event"
            intent.putExtra(CalendarContract.Events.DURATION, meeting!!.nbTime)
            intent.putExtra(CalendarContract.Events.DESCRIPTION, meeting!!.description)
            intent.putExtra(
                CalendarContract.EXTRA_EVENT_BEGIN_TIME, meeting!!.dateStart.toEpochSecond(
                    ZoneOffset.UTC
                ) * 1000
            )
            intent.putExtra(
                CalendarContract.EXTRA_EVENT_END_TIME, meeting!!.getTimeEnd().toEpochSecond(
                    ZoneOffset.UTC
                ) * 1000
            )
            intent.putExtra(CalendarContract.Events.TITLE, meeting!!.name)
            intent.putExtra(CalendarContract.Events.EVENT_LOCATION, meeting!!.getPosition())
            startActivity(intent)
        }

    }

    private fun initGoogleMaps() {
        if (meeting!!.latitude != null && meeting!!.longitude != null) {
            val mapFragment =
                supportFragmentManager.findFragmentById(R.id.google_maps) as? SupportMapFragment
            val positionMeeting = LatLng(meeting!!.latitude!!, meeting!!.longitude!!)
            mapFragment?.getMapAsync { googleMap ->
                googleMap.setMaxZoomPreference(15.0F)
                googleMap.setMinZoomPreference(10.0F)
                googleMap.moveCamera(
                    CameraUpdateFactory.newLatLngZoom(
                        positionMeeting,
                        15.0F
                    )
                )
                googleMap.addMarker(MarkerOptions().position(positionMeeting))
            }
        }
    }

}