package com.cyberacy.app.ui.party.messaging.add_thread

import android.content.Intent
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.PoliticalParty
import com.cyberacy.app.models.entities.PopUpWindow
import com.cyberacy.app.models.entities.ThreadMessaging
import com.cyberacy.app.models.repositories.PartyStateError
import com.cyberacy.app.models.repositories.PartyStateErrorHost
import com.cyberacy.app.models.repositories.PartyStateLoading
import com.cyberacy.app.models.repositories.PartyStateSuccessMine
import com.cyberacy.app.models.services.ApiConnection
import com.google.android.material.button.MaterialButton
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.ktx.storage
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await
import java.io.ByteArrayOutputStream
import java.io.File
import java.net.UnknownHostException
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class AddThreadActivity : AppCompatActivity() {

    private val viewModel: AddThreadViewModel by viewModels()
    private var party: PoliticalParty? = null

    private lateinit var btnAdd: MaterialButton
    private lateinit var imageThread: ImageView
    private lateinit var circularLoader: CircularProgressIndicator
    private lateinit var inputDescription: TextInputEditText
    private lateinit var inputName: TextInputEditText
    private val firebaseStorage = Firebase.storage
    private var urlImage: String? = null
    private var chooseImage = false

    private val resultLogo =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == RESULT_OK || result.resultCode == 100) {
                try{
                    val uriImage: Uri  = result.data!!.data!!
                    imageThread.setImageURI(uriImage)
                    chooseImage = true
                } catch(e: Exception) {
                    Log.e("ERREUR", e.message.toString())
                }
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_thread)

        val loader = findViewById<ProgressBar>(R.id.loader)
        val bodyForm = findViewById<ConstraintLayout>(R.id.layout_form)
        val bodyError = findViewById<ConstraintLayout>(R.id.body_error)
        val bodyErrorHost = findViewById<ConstraintLayout>(R.id.body_error_host)
        val txtError = bodyError.findViewById<TextView>(R.id.txt_error)
        btnAdd = findViewById(R.id.btn_add_thread)
        circularLoader = findViewById(R.id.progress_circular)
        imageThread = findViewById(R.id.logo)
        imageThread.setOnClickListener { openGalleryForImage() }
        inputName = findViewById(R.id.name)
        inputDescription = findViewById(R.id.description)

        btnAdd.setOnClickListener { addThread() }

        designActionBar()

        loader.visibility = View.VISIBLE
        bodyForm.visibility = View.GONE
        bodyErrorHost.visibility = View.GONE
        bodyError.visibility = View.GONE
        viewModel.mineParty.observe(this) {
            when (it) {
                is PartyStateError -> {
                    bodyError.visibility = View.VISIBLE
                    bodyErrorHost.visibility = View.GONE
                    txtError.text = getString(R.string.txt_error_happening, it.ex.message())
                    loader.visibility = View.GONE
                }
                is PartyStateErrorHost -> {
                    bodyErrorHost.visibility = View.VISIBLE
                    loader.visibility = View.GONE
                }
                PartyStateLoading -> {
                    bodyError.visibility = View.GONE
                    bodyErrorHost.visibility = View.GONE
                    loader.visibility = View.VISIBLE
                    bodyForm.visibility = View.GONE
                }
                is PartyStateSuccessMine -> {
                    loader.visibility = View.GONE
                    bodyErrorHost.visibility = View.GONE
                    if(it.party == null) {
                        bodyError.visibility = View.VISIBLE
                        txtError.text = getString(R.string.txt_not_found_party)
                    } else {
                        this.party = it.party
                        bodyError.visibility = View.GONE
                        bodyForm.visibility = View.VISIBLE
                    }
                }
                else -> {}
            }
        }
    }

    private fun addThread() {
        val layoutName = findViewById<TextInputLayout>(R.id.layout_name)
        layoutName.error = null

        if(inputName.text == null || inputName.text!!.isEmpty()) {
            layoutName.error = getString(R.string.txt_required_field)
            return
        }
        circularLoader.visibility = View.VISIBLE
        btnAdd.visibility = View.GONE
        if(chooseImage) {
            postLogoToFirebase()
        } else {
            postNewThread()
        }
    }

    private fun postLogoToFirebase() {
        val formatter = DateTimeFormatter.ofPattern("ddMMyyyyHHmmss")
        val dateString = LocalDateTime.now().format(formatter)
        val nameFirebase = "thread_logo_${dateString}"

        val storageRef = firebaseStorage.reference
        val riversRef = storageRef.child(nameFirebase)
        val bitmap = (imageThread.drawable as BitmapDrawable).bitmap
        val baos = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos)
        val data = baos.toByteArray()
        val uploadTask = riversRef.putBytes(data)
        uploadTask.addOnFailureListener {
            postNewThread()
        }.addOnSuccessListener { taskSnapshot ->
            val path = taskSnapshot.uploadSessionUri!!.path.toString()
            val host = taskSnapshot.uploadSessionUri!!.host.toString()
            urlImage = "https://${host}${path}/${nameFirebase}?alt=media"
            postNewThread()
        }
    }

    private fun postNewThread() {
        val thread = ThreadMessaging(
            id = -1,
            name = inputName.text!!.toString(),
            description = inputDescription.text.toString(),
            urlLogo = urlImage,
            dateCreate = LocalDateTime.now(),
            idPoliticalParty = party!!.id,
            isPrivate = false,
            fcmTopic = "",
            lastMessage = null
        )
        circularLoader.visibility = View.VISIBLE
        btnAdd.visibility = View.GONE
        lifecycleScope.launch {
            try{
                val response = ApiConnection.connection().addThread(thread).await()
                setResult(RESULT_OK, intent)
                finish()
            } catch (e: HttpException) {
                Log.e("ERREUR HTTP", e.message().toString())
                val popup = PopUpWindow(getString(R.string.txt_error_happening, e.message().toString()), R.drawable.ic_error, R.id.layout_add_thread)
                popup.showPopUp(this@AddThreadActivity)
                circularLoader.visibility = View.GONE
                btnAdd.visibility = View.VISIBLE
            } catch (e: UnknownHostException) {
                val popup = PopUpWindow(getString(R.string.txt_connection_host_failure), R.drawable.ic_no_internet, R.id.layout_main)
                popup.showPopUp(this@AddThreadActivity)
                circularLoader.visibility = View.GONE
                btnAdd.visibility = View.VISIBLE
            }
        }
    }

    private fun designActionBar() {
        val actionBar: ActionBar? = supportActionBar
        actionBar?.hide()
        val buttonBack = findViewById<MaterialButton>(R.id.btn_back)
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

    private fun openGalleryForImage() {
        val intent = Intent(Intent.ACTION_PICK)
        intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
        resultLogo.launch(intent)
    }

}