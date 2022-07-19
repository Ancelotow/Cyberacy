package com.cyberacy.app.ui.party.main_party

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.PartyState
import com.cyberacy.app.models.repositories.PoliticalPartyRepository
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class MainPartyViewModel() : ViewModel() {


    private val _party = MutableLiveData<PartyState>()
    val party = _party

    init {
        getMineParty()
    }

    private fun getMineParty() {
        viewModelScope.launch {
            PoliticalPartyRepository.fetchMineParty().collect {
                _party.value = it
            }
        }
    }

}