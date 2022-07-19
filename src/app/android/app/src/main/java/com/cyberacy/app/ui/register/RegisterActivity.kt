package com.cyberacy.app.ui.register

import android.app.DatePickerDialog
import android.content.Intent
import android.content.res.Configuration
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import androidx.activity.viewModels
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.cyberacy.app.R
import com.cyberacy.app.models.entities.*
import com.cyberacy.app.models.repositories.*
import com.cyberacy.app.models.services.ApiConnection
import com.cyberacy.app.ui.navigation.NavigationActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.paypal.pyplcheckout.constants.RESPONSE_CODE_EXCEPTION
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.await
import java.net.UnknownHostException
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.*


class RegisterActivity : AppCompatActivity() {

    private val viewModel: RegisterViewModel by viewModels()

    private lateinit var comboGender: AutoCompleteTextView
    private lateinit var comboTown: AutoCompleteTextView
    private lateinit var comboDepartment: AutoCompleteTextView
    private lateinit var textInputBirthday: TextInputEditText
    private lateinit var textInputFirstname: TextInputEditText
    private lateinit var textInputLastname: TextInputEditText
    private lateinit var textInputNIR: TextInputEditText
    private lateinit var textInputAddress: TextInputEditText
    private lateinit var textInputMail: TextInputEditText
    private lateinit var textInputPassword: TextInputEditText
    private lateinit var textInputPasswordConfirm: TextInputEditText

    private lateinit var layoutGender: TextInputLayout
    private lateinit var layoutFirstname: TextInputLayout
    private lateinit var layoutLastname: TextInputLayout
    private lateinit var layoutBirthday: TextInputLayout
    private lateinit var layoutNIR: TextInputLayout
    private lateinit var layoutAddress: TextInputLayout
    private lateinit var layoutDepartment: TextInputLayout
    private lateinit var layoutTown: TextInputLayout
    private lateinit var layoutMail: TextInputLayout
    private lateinit var layoutPassword: TextInputLayout
    private lateinit var layoutPasswordConfirm: TextInputLayout

    private lateinit var btnRegister: MaterialButton
    private lateinit var circularProgress: CircularProgressIndicator

    private var departmentSelected: Department? = null
    private var townSelected: Town? = null
    private var genderSelected: Gender? = null
    private var birthdayDate: LocalDateTime? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_register)
        designActionBar()

        comboGender = findViewById(R.id.genre)
        comboDepartment = findViewById(R.id.department)
        comboTown = findViewById(R.id.town)
        textInputBirthday = findViewById(R.id.birthday)

        textInputFirstname = findViewById(R.id.firstname)
        textInputLastname = findViewById(R.id.lastname)
        textInputNIR = findViewById(R.id.nir)
        textInputAddress = findViewById(R.id.address)
        textInputMail = findViewById(R.id.email)
        textInputPassword = findViewById(R.id.password)
        textInputPasswordConfirm = findViewById(R.id.confirm_password)

        layoutGender = findViewById(R.id.layout_genre)
        layoutFirstname = findViewById(R.id.layout_firstname)
        layoutLastname = findViewById(R.id.layout_lastname)
        layoutBirthday = findViewById(R.id.layout_birthday)
        layoutNIR = findViewById(R.id.layout_nir)
        layoutAddress = findViewById(R.id.layout_address)
        layoutDepartment = findViewById(R.id.layout_dept)
        layoutTown = findViewById(R.id.layout_town)
        layoutMail = findViewById(R.id.layout_email)
        layoutPassword = findViewById(R.id.layout_password)
        layoutPasswordConfirm = findViewById(R.id.layout_confirm_password)

        btnRegister = findViewById(R.id.btn_register)
        circularProgress = findViewById(R.id.progress_circular)

        viewModel.getGenders()
        viewModel.getDepartments()

        initListGender()
        initListDepartment()
        initListTown()
        initBirthdayPicker()

        btnRegister.setOnClickListener { register() }
    }

    private fun initListGender() {
        comboGender.isEnabled = false
        viewModel.listGenders.observe(this) {
            when (it) {
                is GenderStateError -> {
                    comboGender.isEnabled = false
                    Log.e("error", it.ex.message())
                }
                GenderStateLoading -> {
                    comboGender.isEnabled = false
                }
                is GenderStateSuccess -> {
                    comboGender.isEnabled = true
                    comboGender.setAdapter(
                        ArrayAdapter(
                            this,
                            android.R.layout.simple_dropdown_item_1line,
                            it.genders
                        )
                    )
                    comboGender.setOnItemClickListener { parent, view, position, id -> genderSelected = it.genders[position] }
                }
            }
        }
    }

    private fun initListDepartment() {
        comboDepartment.isEnabled = false
        viewModel.listDepartment.observe(this) {
            when (it) {
                is DepartmentStateError -> {
                    comboDepartment.isEnabled = false
                    Log.e("error", it.ex.message())
                }
                DepartmentStateLoading -> {
                    comboDepartment.isEnabled = false
                }
                is DepartmentStateSuccess -> {
                    comboDepartment.isEnabled = true
                    comboDepartment.setAdapter(
                        ArrayAdapter(
                            this,
                            android.R.layout.simple_dropdown_item_1line,
                            it.departments
                        )
                    )
                    comboDepartment.setOnItemClickListener { parent, view, position, id ->
                        departmentSelected = it.departments[position]
                        viewModel.getTowns(departmentSelected!!.code)
                    }
                }
            }
        }
    }

    private fun initListTown() {
        comboTown.isEnabled = false
        viewModel.listTown.observe(this) {
            when (it) {
                is TownStateError -> {
                    comboTown.isEnabled = false
                    Log.e("error", it.ex.message())
                }
                TownStateLoading -> {
                    comboTown.isEnabled = false
                }
                is TownStateSuccess -> {
                    comboTown.isEnabled = true
                    comboTown.setAdapter(
                        ArrayAdapter(
                            this,
                            android.R.layout.simple_dropdown_item_1line,
                            it.towns
                        )
                    )
                    comboTown.setOnItemClickListener { parent, view, position, id -> townSelected = it.towns[position] }
                }
            }
        }
    }

    private fun initBirthdayPicker() {
        val calendarBirthday = Calendar.getInstance()
        val datePicker = DatePickerDialog.OnDateSetListener { view, year, month, day ->
            calendarBirthday.set(Calendar.YEAR, year)
            calendarBirthday.set(Calendar.MONTH, month)
            calendarBirthday.set(Calendar.DAY_OF_MONTH, day)
            val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.FRANCE)
            textInputBirthday.setText(dateFormat.format(calendarBirthday.time))
            birthdayDate = LocalDateTime.ofInstant(calendarBirthday.toInstant(), ZoneId.systemDefault())
        }
        textInputBirthday.setOnClickListener {
            DatePickerDialog(
                this@RegisterActivity,
                datePicker,
                calendarBirthday.get(Calendar.YEAR),
                calendarBirthday.get(Calendar.MONTH),
                calendarBirthday.get(Calendar.DAY_OF_MONTH)
            ).show()
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

    private fun register() {
        var isValid = true

        layoutGender.error = null
        layoutFirstname.error = null
        layoutLastname.error = null
        layoutBirthday.error = null
        layoutNIR.error = null
        layoutAddress.error = null
        layoutDepartment.error = null
        layoutTown.error = null
        layoutMail.error = null
        layoutPassword.error = null
        layoutPasswordConfirm.error = null

        if(genderSelected == null) {
            layoutGender.error = getString(R.string.txt_required_field)
            isValid = false
        }
        if(textInputFirstname.text == null || textInputFirstname.text!!.isEmpty()) {
            layoutFirstname.error = getString(R.string.txt_required_field)
            isValid = false
        }
        if(textInputLastname.text == null || textInputLastname.text!!.isEmpty()) {
            layoutLastname.error = getString(R.string.txt_required_field)
            isValid = false
        }

        if(birthdayDate == null) {
            layoutBirthday.error = getString(R.string.txt_required_field)
            isValid = false
        } else if(birthdayDate!!.isAfter(LocalDateTime.now().minusYears(18))) {
            layoutBirthday.error = getString(R.string.txt_error_minor)
            isValid = false
        }

        if(textInputNIR.text == null || textInputNIR.text!!.isEmpty()) {
            layoutNIR.error = getString(R.string.txt_required_field)
            isValid = false
        } else if (textInputNIR.text!!.length != 13) {
            layoutNIR.error = getString(R.string.txt_error_nir_short)
            isValid = false
        }

        if(textInputAddress.text == null || textInputAddress.text!!.isEmpty()) {
            layoutAddress.error = getString(R.string.txt_required_field)
            isValid = false
        }
        if(departmentSelected == null) {
            layoutDepartment.error = getString(R.string.txt_required_field)
            isValid = false
        }
        if(townSelected == null) {
            layoutTown.error = getString(R.string.txt_required_field)
            isValid = false
        }

        if(textInputMail.text == null || textInputMail.text!!.isEmpty()) {
            layoutMail.error = getString(R.string.txt_required_field)
            isValid = false
        } else if (!textInputMail.text!!.contains("@")) {
            layoutMail.error = getString(R.string.txt_error_not_email)
            isValid = false
        }

        if(textInputPassword.text == null || textInputPassword.text!!.isEmpty()) {
            layoutPassword.error = getString(R.string.txt_required_field)
            isValid = false
        } else if (textInputPasswordConfirm.text.toString() != textInputPassword.text.toString()) {
            layoutPassword.error = getString(R.string.txt_error_not_same_pwd)
            layoutPasswordConfirm.error = getString(R.string.txt_error_not_same_pwd)
            isValid = false
        }

        if(isValid) {
            addNewPerson()
        }
    }

    private fun addNewPerson() {
        val person = Person(
            nir = textInputNIR.text.toString(),
            firstname = textInputFirstname.text.toString(),
            lastname = textInputLastname.text.toString(),
            birthday = birthdayDate!!.format(DateTimeFormatter.ISO_LOCAL_DATE),
            sex = genderSelected!!.id,
            address_street = textInputAddress.text.toString(),
            townCodeInsee = townSelected!!.codeInsee,
            email = textInputMail.text.toString(),
            password = textInputPassword.text.toString(),
            profile = 4,
            token = null,
            town = null
        )

        circularProgress.visibility = View.VISIBLE
        btnRegister.visibility = View.GONE
        lifecycleScope.launch {
            try{
                val response = ApiConnection.connection().register(person).await()
                setResult(RESULT_OK, intent)
                finish()
            } catch (e: HttpException) {
                Log.e("ERREUR HTTP", e.message().toString())
                if(e.code() == 400) {
                    val popup = PopUpWindow(getString(R.string.txt_account_already_existed), R.drawable.ic_warning, R.id.layout_register)
                    popup.showPopUp(this@RegisterActivity)
                } else {
                    val popup = PopUpWindow(getString(R.string.txt_error_happening, e.message().toString()), R.drawable.ic_error, R.id.layout_register)
                    popup.showPopUp(this@RegisterActivity)
                }
                circularProgress.visibility = View.GONE
                btnRegister.visibility = View.VISIBLE
            } catch (e: UnknownHostException) {
                val popup = PopUpWindow(getString(R.string.txt_cannot_communicate), R.drawable.ic_no_internet, R.id.layout_main)
                popup.showPopUp(this@RegisterActivity)
                circularProgress.visibility = View.GONE
                btnRegister.visibility = View.VISIBLE
            }
        }
    }

}