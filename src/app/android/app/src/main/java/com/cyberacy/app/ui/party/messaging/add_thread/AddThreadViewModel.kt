package com.cyberacy.app.ui.party.messaging.add_thread

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.PartyState
import com.cyberacy.app.models.repositories.PoliticalPartyRepository
import kotlinx.coroutines.launch

class AddThreadViewModel   : ViewModel() {

    private val _party = MutableLiveData<PartyState>()
    val mineParty = _party

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