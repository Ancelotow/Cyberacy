package com.cyberacy.app.ui.vote.round_vote

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.RoundRepository
import com.cyberacy.app.models.repositories.RoundState
import kotlinx.coroutines.launch

class RoundViewModel(private val id: Int) : ViewModel() {

    private val _rounds = MutableLiveData<RoundState>()
    val listRounds = _rounds

    class Factory(private val id: Int) : ViewModelProvider.Factory {

        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return RoundViewModel(id) as T
        }

    }

    init {
        getRounds()
    }

    private fun getRounds() {
        viewModelScope.launch {
            RoundRepository.fetchRound(id).collect {
                _rounds.value = it
            }
        }
    }

}