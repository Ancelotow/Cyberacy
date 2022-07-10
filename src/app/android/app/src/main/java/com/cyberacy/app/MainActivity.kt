package com.cyberacy.app

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.ActionBar
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.models.entities.Connection
import com.cyberacy.app.models.entities.Session
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.navigation.NavigationActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await

class MainActivity : AppCompatActivity() {
    
    lateinit var login: TextInputEditText
    lateinit var password: TextInputEditText
    lateinit var layoutLogin: TextInputLayout
    lateinit var layoutPassword: TextInputLayout
    lateinit var btnConnection: MaterialButton
    lateinit var circularProgress: CircularProgressIndicator

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        login = findViewById(R.id.login)
        password = findViewById(R.id.password)
        layoutLogin = findViewById(R.id.layout_login)
        layoutPassword = findViewById(R.id.layout_password)
        btnConnection = findViewById(R.id.btnConnection)
        circularProgress = findViewById(R.id.progress_circular)
        btnConnection.setOnClickListener { this.connection() }
    }

    private fun connection() {
        layoutLogin.error = null
        layoutPassword.error = null
        val nir = this.login.text.toString()
        val pwd = this.password.text.toString()

        if (nir.isEmpty()) {
            layoutLogin.error = "Ce champ est obligatoire"
            return
        } else if(pwd.isEmpty()) {
            layoutPassword.error = "Ce champ est obligatoire"
            return
        }

        circularProgress.visibility = View.VISIBLE
        btnConnection.visibility = View.GONE
        lifecycleScope.launch {
            val infoConnection = Connection(nir, pwd)
            try{
                val response = ApiConnection.connection().login(infoConnection).await()
                if(response.data != null) {
                    Session.openSession(response.data)
                    val i = Intent(this@MainActivity, NavigationActivity::class.java)
                    startActivity(i)
                }
            } catch (e: HttpException) {
                if(e.code() == 401) {
                    layoutLogin.error = "L'identidiant et/ou le mot de passe sont incorrects"
                    password.text = null
                }
            } finally {
                circularProgress.visibility = View.GONE
                btnConnection.visibility = View.VISIBLE
            }
        }
    }

}
