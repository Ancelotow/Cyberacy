package com.cyberacy.app.models.entities

import android.graphics.Point
import android.view.*
import android.widget.ImageView
import android.widget.PopupWindow
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.cyberacy.app.R
import com.google.android.material.button.MaterialButton

class PopUpWindow(val message: String, private val iconResource: Int) {

    fun showPopUp(activity: AppCompatActivity) {
        val inflater =
            activity.getSystemService(AppCompatActivity.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val popupView: View = inflater.inflate(R.layout.pop_up_activity, null)

        popupView.findViewById<TextView>(R.id.message).text = message
        popupView.findViewById<ImageView>(R.id.icon).setImageResource(iconResource)

        val display: Display = activity.windowManager.defaultDisplay
        val size = Point()
        display.getSize(size)
        val popup = PopupWindow(
            popupView,
            size.x - 20,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        popupView.findViewById<MaterialButton>(R.id.btn_close)
            .setOnClickListener { popup.dismiss() }
        popup.elevation = 5.0F
        popup.showAtLocation(
            activity.findViewById(R.id.layout_meeting_details),
            Gravity.CENTER,
            0,
            0
        )
    }

}