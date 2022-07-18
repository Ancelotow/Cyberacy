package com.cyberacy.app.ui.register

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.*
import kotlinx.coroutines.launch

class RegisterViewModel : ViewModel() {

    private val _town = MutableLiveData<TownState>()
    private val _department = MutableLiveData<DepartmentState>()
    private val _gender = MutableLiveData<GenderState>()

    val listDepartment = _department
    val listTown = _town
    val listGenders = _gender

    fun getDepartments() {
        viewModelScope.launch {
            DepartmentRepository.fetchDepartment().collect {
                _department.value = it
            }
        }
    }

    fun getTowns(codeDept: String) {
        viewModelScope.launch {
            TownRepository.fetchTownFromDepartment(codeDept).collect {
                _town.value = it
            }
        }
    }

    fun getGenders() {
        viewModelScope.launch {
            GenderRepository.fetchGender().collect {
                _gender.value = it
            }
        }
    }

}