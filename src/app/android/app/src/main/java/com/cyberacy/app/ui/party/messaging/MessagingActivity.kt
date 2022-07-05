package com.cyberacy.app.ui.party.messaging

import android.content.res.Configuration
import android.graphics.PorterDuff
import android.os.Bundle
import android.widget.ImageView
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentTransaction
import com.cyberacy.app.R
import com.cyberacy.app.ui.party.messaging.my_threads.MyThreadsFragment
import com.cyberacy.app.ui.party.messaging.other_threads.OtherThreadsFragment
import com.google.android.material.tabs.TabLayout

class MessagingActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_messaging)
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()

        val logoMsg = findViewById<ImageView>(R.id.logo_msg)
        var colorIcon = android.R.color.black
        when (resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
            Configuration.UI_MODE_NIGHT_YES -> {colorIcon = android.R.color.white}
            Configuration.UI_MODE_NIGHT_NO -> {colorIcon = android.R.color.black}
            Configuration.UI_MODE_NIGHT_UNDEFINED -> {colorIcon = android.R.color.black}
        }
        logoMsg.setColorFilter(resources.getColor(colorIcon), PorterDuff.Mode.SRC_IN);

        val tabs = findViewById<TabLayout>(R.id.tabs)
        changeFragment(MyThreadsFragment())
        tabs.addOnTabSelectedListener(object:TabLayout.OnTabSelectedListener {
            override fun onTabSelected(tab : TabLayout.Tab) {

                when (tab.position) {
                    0 -> changeFragment(MyThreadsFragment())
                    1 -> changeFragment(OtherThreadsFragment())
                }
            }
            override fun onTabUnselected(p0: TabLayout.Tab?) {

            }
            override fun onTabReselected(p0: TabLayout.Tab?) {

            }
        })
    }

    fun changeFragment(view: Fragment) {
        val transaction: FragmentTransaction = supportFragmentManager.beginTransaction()
        transaction.replace(R.id.messaging_view, view).commit()
    }

}