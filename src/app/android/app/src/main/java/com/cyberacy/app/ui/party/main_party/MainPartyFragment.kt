package com.cyberacy.app.ui.party.main_party

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.Meeting
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.party.meeting.ListMeetingActivity
import com.cyberacy.app.ui.party.messaging.MessagingActivity
import com.google.android.material.button.MaterialButton
import com.squareup.picasso.Picasso
import kotlinx.coroutines.launch
import retrofit2.await
import java.util.*

private const val ARG_PARAM = "id_party"

class MainPartyFragment : Fragment() {

    private val viewModel: MainPartyViewModel by viewModels()
    private var idParty: Int? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            idParty = it.getInt(ARG_PARAM)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_main_party, container, false)
    }

    companion object {
        fun newInstance(id: Int) = MainPartyFragment().apply {
            arguments = Bundle().apply {
                putInt(ARG_PARAM, id)
            }
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val body = view.findViewById<ConstraintLayout>(R.id.body_main_party)
        val loader = view.findViewById<ProgressBar>(R.id.loader_main_party)
        val name = view.findViewById<TextView>(R.id.title)
        val logo = view.findViewById<ImageView>(R.id.logo)
        val cardMsg = view.findViewById<CardView>(R.id.card_messagerie)
        loader.visibility = View.VISIBLE
        body.visibility = View.GONE
        lifecycleScope.launch {
            val listsParties = ApiConnection.connection().getPoliticalParty(false, idParty).await()
            if(listsParties == null || listsParties.isEmpty()) {
                Log.v("Party", "None")
            } else {
                val party = listsParties[0]
                name.text = party.name
                Picasso.get().load(party.urlLogo).into(logo)
                initNextMeeting(party.nextMeeting)
            }
            loader.visibility = View.GONE
            body.visibility = View.VISIBLE
        }
        cardMsg.setOnClickListener {
            val intent = Intent(view.context, MessagingActivity::class.java)
            startActivity(intent)
        }
    }

    fun initNextMeeting(meeting: Meeting?) {
        val infoNoMeeting = view?.findViewById<TextView>(R.id.info_no_meeting)
        val btnMoreMeeting = view?.findViewById<MaterialButton>(R.id.btn_more_meeting)
        val nextMeeting = view?.findViewById<ConstraintLayout>(R.id.next_meeting)
        if(meeting == null) {
            infoNoMeeting?.visibility = View.VISIBLE
            btnMoreMeeting?.visibility = View.GONE
            nextMeeting?.visibility = View.GONE
        } else {
            infoNoMeeting?.visibility = View.GONE
            btnMoreMeeting?.visibility = View.VISIBLE
            nextMeeting?.visibility = View.VISIBLE
            view?.findViewById<TextView>(R.id.txt_month)?.text = meeting.getMonthPrefix()
            view?.findViewById<TextView>(R.id.txt_day)?.text = meeting.dateStart.dayOfMonth.toString()
            view?.findViewById<TextView>(R.id.txt_name)?.text = meeting.name
            view?.findViewById<TextView>(R.id.txt_lieu)?.text = meeting.getPlace()
            view?.findViewById<TextView>(R.id.txt_price)?.text = "Prix : ${meeting.getPriceStr()}"
            nextMeeting?.isClickable = true
            nextMeeting?.setOnClickListener {
                /*val intent = Intent(view?.context, MeetingDetailActivity::class.java)
                intent.putExtra("idMeeting", meeting.id)
                startActivity(intent)*/
                val cal: Calendar = Calendar.getInstance()
                val intent = Intent(Intent.ACTION_EDIT)
                intent.type = "vnd.android.cursor.item/event"
                intent.putExtra("beginTime", cal.getTimeInMillis())
                intent.putExtra("allDay", true)
                intent.putExtra("rrule", "FREQ=YEARLY")
                intent.putExtra("endTime", cal.getTimeInMillis() + 60 * 60 * 1000)
                intent.putExtra("title", "A Test Event from android app")
                startActivity(intent)
            }
            btnMoreMeeting?.setOnClickListener {
                val intent = Intent(view?.context, ListMeetingActivity::class.java)
                intent.putExtra("idParty", idParty)
                startActivity(intent)
            }
        }
    }

}