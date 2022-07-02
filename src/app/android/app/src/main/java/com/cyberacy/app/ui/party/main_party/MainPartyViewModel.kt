package com.cyberacy.app.ui.party.main_party

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.PartyState
import com.cyberacy.app.models.repositories.PoliticalPartyRepository
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class MainPartyViewModel(val id: Int) : ViewModel() {


    private val _party = MutableLiveData<PartyState>()
    val party = _party

    init {
        getPartyById(id)
    }

    fun getPartyById(id: Int) {
        viewModelScope.launch {
            PoliticalPartyRepository.fetchPartyById(id).collect {
                _party.value = it
            }
        }
    }

}