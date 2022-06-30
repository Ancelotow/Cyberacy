package com.cyberacy.app.ui.party.join_party

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.PartyState
import com.cyberacy.app.models.repositories.PoliticalPartyRepository
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class JoinPartyViewModel : ViewModel() {

    private val _parties = MutableLiveData<PartyState>()

    val listParty = _parties

    init {
        getAllParties()
    }

    fun getAllParties() {
        viewModelScope.launch {
            PoliticalPartyRepository.fetchPoliticalParties().collect {
                _parties.value = it
            }
        }
    }

}