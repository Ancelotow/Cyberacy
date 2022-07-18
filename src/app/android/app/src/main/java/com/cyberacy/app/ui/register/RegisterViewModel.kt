package com.cyberacy.app.ui.register

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.*
import kotlinx.coroutines.launch

class RegisterViewModel : ViewModel() {

    private val _town = MutableLiveData<TownState>()
    private val _department = MutableLiveData<DepartmentState>()

    val listDepartment = _department
    val listTown = _town

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

}