package com.cyberacy.app.ui.navigation

import android.os.Bundle
import androidx.appcompat.app.ActionBar
import com.google.android.material.bottomnavigation.BottomNavigationView
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentContainerView
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.NavigationUI.setupWithNavController
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.FCMTopic

class NavigationActivity : AppCompatActivity() {

    private lateinit var navBar: BottomNavigationView
    private lateinit var hostView: FragmentContainerView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_navigation)

        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()

        navBar = findViewById(R.id.nav_bar)
        hostView = findViewById(R.id.host_view)

        val navHost = supportFragmentManager.findFragmentById(R.id.host_view) as NavHostFragment
        setupWithNavController(navBar, navHost.navController)

        FCMTopic.subscribeAllTopic(this)
    }


}