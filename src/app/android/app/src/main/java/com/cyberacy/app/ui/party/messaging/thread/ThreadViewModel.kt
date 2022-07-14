package com.cyberacy.app.ui.party.messaging.thread

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.MessageRepository
import com.cyberacy.app.models.repositories.MessageState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class ThreadViewModel(private val id: Int) : ViewModel() {

    private val _messages = MutableLiveData<MessageState>()
    val messages = _messages

    class Factory(private val id: Int) : ViewModelProvider.Factory {

        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return ThreadViewModel(id) as T
        }

    }

    init {
        getMessages()
    }

    private fun getMessages() {
        viewModelScope.launch {
            MessageRepository.fetchMessages(id).collect {
                _messages.value = it
            }
        }
    }

}