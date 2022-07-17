package com.cyberacy.app.ui.meeting.meeting_ticket

import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.widget.NestedScrollView
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.MeetingQrCode
import com.cyberacy.app.models.repositories.*
import com.google.android.material.button.MaterialButton
import com.google.gson.Gson
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.qrcode.QRCodeWriter
import java.time.format.DateTimeFormatter
import kotlin.properties.Delegates

class MeetingTicketActivity : AppCompatActivity() {

    private lateinit var viewModel: MeetingTicketViewModel
    private var idMeeting by Delegates.notNull<Int>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_meeting_ticket)
        idMeeting = intent.getIntExtra("idMeeting", 0)
        val vm: MeetingTicketViewModel by viewModels { MeetingTicketViewModel.Factory(idMeeting) }
        viewModel = vm
        designActionBar()
        initMeeting()
    }

    private fun initMeeting() {
        val loader = findViewById<ProgressBar>(R.id.loader)
        val iconError = findViewById<ImageView>(R.id.img_error)
        val txtError = findViewById<TextView>(R.id.txt_error)
        loader.visibility = View.VISIBLE
        viewModel.meetingQrcode.observe(this) {
            when (it) {
                is MeetingQRCodeStateError -> {
                    Log.e("error", it.ex.message())
                    loader.visibility = View.GONE
                    iconError.visibility = View.VISIBLE
                    txtError.visibility = View.VISIBLE
                    txtError.text =  getString(R.string.txt_error_happening, it.ex.message())
                }
                MeetingQRCodeStateLoading -> {
                    loader.visibility = View.VISIBLE
                }
                is MeetingQRCodeStateSuccess -> {
                    loader.visibility = View.GONE
                    if (it.meetingQrcode == null) {
                        iconError.visibility = View.VISIBLE
                        txtError.visibility = View.VISIBLE
                        txtError.text = getString(R.string.txt_not_found_ticket)
                    } else {
                        initInformation(it.meetingQrcode)
                    }
                }
            }
        }
    }

    private fun initInformation(meetingQrCode: MeetingQrCode) {
        setBrightnessToMax()
        val formatterDate: DateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
        val qrCode = getQrCodeBitmap(meetingQrCode)
        val imgView = findViewById<ImageView>(R.id.img_qrcode)
        imgView.setImageBitmap(qrCode)
        findViewById<TextView>(R.id.meeting_name).text = meetingQrCode.name
        val userName = "${meetingQrCode.firstname} ${meetingQrCode.lastname.uppercase()}"
        findViewById<TextView>(R.id.user_name).text = userName
        findViewById<TextView>(R.id.meeting_date).text = formatterDate.format(meetingQrCode.dateStart)
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

    private fun setBrightnessToMax() {
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        val params = window.attributes
        params.screenBrightness = 1.0f
        window.attributes = params
    }

    private fun getQrCodeBitmap(meetingQrCode: MeetingQrCode): Bitmap {
        val size = 512 //pixels
        val qrCodeContent = Gson().toJson(meetingQrCode)
        Log.e("GSON", qrCodeContent)
        val hints = hashMapOf<EncodeHintType, Int>().also { it[EncodeHintType.MARGIN] = 1 } // Make the QR code buffer border narrower
        val bits = QRCodeWriter().encode(qrCodeContent, BarcodeFormat.QR_CODE, size, size)
        return Bitmap.createBitmap(size, size, Bitmap.Config.RGB_565).also {
            for (x in 0 until size) {
                for (y in 0 until size) {
                    it.setPixel(x, y, if (bits[x, y]) Color.BLACK else Color.WHITE)
                }
            }
        }
    }
}