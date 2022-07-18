package com.cyberacy.app

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.models.entities.Connection
import com.cyberacy.app.models.entities.PopUpWindow
import com.cyberacy.app.models.entities.Session
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.navigation.NavigationActivity
import com.cyberacy.app.ui.register.RegisterActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.google.firebase.messaging.FirebaseMessaging
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await
import java.io.IOException

class MainActivity : AppCompatActivity() {
    
    lateinit var login: TextInputEditText
    lateinit var password: TextInputEditText
    lateinit var layoutLogin: TextInputLayout
    lateinit var layoutPassword: TextInputLayout
    lateinit var btnConnection: MaterialButton
    lateinit var btnRegister: MaterialButton
    lateinit var circularProgress: CircularProgressIndicator

    private val resultLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == RESULT_OK) {
                val popup = PopUpWindow(getString(R.string.txt_account_created), R.drawable.ic_success, R.id.layout_main)
                popup.showPopUp(this)
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        unsubscribeAllTopic()
        login = findViewById(R.id.login)
        password = findViewById(R.id.password)
        layoutLogin = findViewById(R.id.layout_login)
        layoutPassword = findViewById(R.id.layout_password)
        btnConnection = findViewById(R.id.btnConnection)
        btnRegister = findViewById(R.id.btn_register)
        circularProgress = findViewById(R.id.progress_circular)
        btnConnection.setOnClickListener { this.connection() }
        btnRegister.setOnClickListener {
            val i = Intent(this@MainActivity, RegisterActivity::class.java)
            resultLauncher.launch(i)
        }
    }

    private fun connection() {
        layoutLogin.error = null
        layoutPassword.error = null
        val nir = this.login.text.toString()
        val pwd = this.password.text.toString()

        if (nir.isEmpty()) {
            layoutLogin.error = getString(R.string.txt_required_field)
            return
        } else if(pwd.isEmpty()) {
            layoutPassword.error = getString(R.string.txt_required_field)
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
                    layoutLogin.error = getString(R.string.txt_error_login)
                    password.text = null
                }
            } finally {
                circularProgress.visibility = View.GONE
                btnConnection.visibility = View.VISIBLE
            }
        }
    }

    private fun unsubscribeAllTopic() {
        FirebaseMessaging.getInstance().deleteToken()
    }

}
