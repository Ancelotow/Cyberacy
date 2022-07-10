package com.cyberacy.app.ui.meeting.meeting_ticket

import android.graphics.Bitmap
import android.graphics.Color
import android.os.Bundle
import android.view.WindowManager
import android.widget.ImageView
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import com.cyberacy.app.R
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.qrcode.QRCodeWriter

class MeetingTicketActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_meeting_ticket)
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()

        val qrCode = getQrCodeBitmap()
        val imgView = findViewById<ImageView>(R.id.img_qrcode)
        imgView.setImageBitmap(qrCode)
        setBrightnessToMax()
    }

    private fun setBrightnessToMax() {
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        val params = window.attributes
        params.screenBrightness = 1.0f
        window.attributes = params
    }

    private fun getQrCodeBitmap(): Bitmap {
        val size = 512 //pixels
        val qrCodeContent = "FIRSTNAME:OWEN;LASTNAME:ANCELOT;ID_MEE:2"
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