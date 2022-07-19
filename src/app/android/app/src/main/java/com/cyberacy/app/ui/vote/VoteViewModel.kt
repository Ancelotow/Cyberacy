package com.cyberacy.app.ui.vote

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.VoteRepository
import com.cyberacy.app.models.repositories.VoteState
import kotlinx.coroutines.launch

class VoteViewModel : ViewModel() {

    private val _votes = MutableLiveData<VoteState>()
    val listVotes = _votes

    init {
        getListVotes()
    }

    private fun getListVotes() {
        viewModelScope.launch {
            VoteRepository.fetchVoteInProgress().collect {
                _votes.value = it
            }
        }
    }

}