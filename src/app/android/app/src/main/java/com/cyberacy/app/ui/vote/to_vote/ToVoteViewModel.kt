package com.cyberacy.app.ui.vote.to_vote

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.ChoiceRepository
import com.cyberacy.app.models.repositories.ChoiceState
import kotlinx.coroutines.launch

class ToVoteViewModel(private val idVote: Int, private val idRound: Int) : ViewModel() {

    private val _choices = MutableLiveData<ChoiceState>()
    val listChoice = _choices

    class Factory(private val idVote: Int, private val idRound: Int) : ViewModelProvider.Factory {

        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return ToVoteViewModel(idVote, idRound) as T
        }

    }

    init {
        getChoices()
    }

    private fun getChoices() {
        viewModelScope.launch {
            ChoiceRepository.fetchChoice(idVote, idRound).collect {
                _choices.value = it
            }
        }
    }

}