package com.cyberacy.app.ui.party.main_party

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.cardview.widget.CardView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.FCMTopic
import com.cyberacy.app.models.entities.Meeting
import com.cyberacy.app.models.entities.PoliticalParty
import com.cyberacy.app.models.repositories.PartyStateError
import com.cyberacy.app.models.repositories.PartyStateLoading
import com.cyberacy.app.models.repositories.PartyStateSuccessMine
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.meeting.ListMeetingActivity
import com.cyberacy.app.ui.meeting.meeting_detail.MeetingDetailActivity
import com.cyberacy.app.ui.meeting.meeting_ticket.MeetingTicketActivity
import com.cyberacy.app.ui.party.PartyFragment
import com.cyberacy.app.ui.party.join_party.JoinPartyFragment
import com.cyberacy.app.ui.party.messaging.MessagingActivity
import com.google.android.material.button.MaterialButton
import com.google.firebase.ktx.Firebase
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.ktx.messaging
import com.squareup.picasso.Picasso
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await

class MainPartyFragment : Fragment() {

    private val viewModel: MainPartyViewModel by viewModels()
    private var party: PoliticalParty? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_main_party, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initParty()
        if(activity != null && activity is AppCompatActivity) {
            FCMTopic.subscribeAllTopic(activity!! as AppCompatActivity)
        }
    }

    private fun initParty() {
        val body = view!!.findViewById<ConstraintLayout>(R.id.body_main_party)
        val errorBody = view!!.findViewById<ConstraintLayout>(R.id.error_party)
        val loader = view!!.findViewById<ProgressBar>(R.id.loader_main_party)
        val txtError = view!!.findViewById<TextView>(R.id.txt_error)
        val name = view!!.findViewById<TextView>(R.id.title)
        val logo = view!!.findViewById<ImageView>(R.id.logo)
        val cardMsg = view!!.findViewById<CardView>(R.id.card_messagerie)
        val btnLeft = view!!.findViewById<MaterialButton>(R.id.btn_left)
        loader.visibility = View.VISIBLE
        body.visibility = View.GONE
        viewModel.party.observe(viewLifecycleOwner) {
            when (it) {
                is PartyStateError -> {
                    loader.visibility = View.GONE
                    errorBody.visibility = View.VISIBLE
                    txtError.text = getString(R.string.txt_error_happening, it.ex.message())
                }
                PartyStateLoading -> {
                    body.visibility = View.GONE
                    loader.visibility = View.VISIBLE
                }
                is PartyStateSuccessMine -> {

                    loader.visibility = View.GONE
                    if(it.party == null) {
                        errorBody.visibility = View.VISIBLE
                        txtError.text = context!!.getString(R.string.txt_not_found_party)
                    } else {
                        this.party = it.party
                        body.visibility = View.VISIBLE
                        name.text = this.party!!.name
                        Picasso.get().load(this.party!!.urlLogo).into(logo)
                        initNextMeeting(this.party!!.nextMeeting)
                        cardMsg.setOnClickListener {
                            val intent = Intent(view!!.context, MessagingActivity::class.java)
                            startActivity(intent)
                        }
                        btnLeft.setOnClickListener { leaveParty() }
                    }
                }
                else -> {}
            }
        }
    }

    private fun initNextMeeting(meeting: Meeting?) {
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
            view?.findViewById<TextView>(R.id.txt_lieu)?.text = meeting.getPosition()
            view?.findViewById<TextView>(R.id.txt_price)?.text = getString(R.string.txt_meeting_price, meeting.getPriceStr())
            val btnQrcode = view?.findViewById<MaterialButton>(R.id.btn_qrcode)
            if(meeting.isParticipated) {
                btnQrcode?.visibility = View.VISIBLE
                btnQrcode?.setOnClickListener {
                    val intent = Intent(context, MeetingTicketActivity::class.java)
                    intent.putExtra("idMeeting", meeting.id)
                    context?.startActivity(intent)
                }
            }
            nextMeeting?.isClickable = true
            nextMeeting?.setOnClickListener {
                val intent = Intent(view?.context, MeetingDetailActivity::class.java)
                intent.putExtra("idMeeting", meeting.id)
                intent.putExtra("nameMeeting", meeting.name)
                startActivity(intent)
            }
            btnMoreMeeting?.setOnClickListener {
                val intent = Intent(view?.context, ListMeetingActivity::class.java)
                intent.putExtra("idParty", party?.id)
                startActivity(intent)
            }
        }
    }

    private fun leaveParty() {
        val alertDialogBuilder = AlertDialog.Builder(context)
        alertDialogBuilder.setTitle(R.string.txt_join_thread)
        alertDialogBuilder.setMessage(getString(R.string.txt_leave_party_confirmation))
        val loader = view!!.findViewById<ProgressBar>(R.id.loader_main_party)
        alertDialogBuilder.setPositiveButton(R.string.btn_yes) { dialog, which ->
            lifecycleScope.launch {
                activity?.window?.setFlags(
                    WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
                    WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                )
                loader.visibility = View.VISIBLE
                try {
                    ApiConnection.connection().leaveParty().await()
                    loader.visibility = View.GONE
                    activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE)

                    FirebaseMessaging.getInstance().deleteToken()
                    if(activity != null && activity is AppCompatActivity) {
                        FCMTopic.subscribeAllTopic(activity!! as AppCompatActivity)
                    }

                    (parentFragment!! as PartyFragment).refresh()
                } catch (e: HttpException) {
                    if (e.code() == 401) {
                        Log.e("Erreur 401", e.message())
                    }
                    loader.visibility = View.GONE
                    activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE)
                }
            }
        }
        alertDialogBuilder.setNegativeButton(R.string.btn_no) { dialog, which ->
            Toast.makeText(context, R.string.txt_join_party_cancel, Toast.LENGTH_SHORT).show()
        }
        alertDialogBuilder.show()
    }

}