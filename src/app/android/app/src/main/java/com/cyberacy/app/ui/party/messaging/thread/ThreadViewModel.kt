package com.cyberacy.app.ui.party.messaging.thread

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.MessageRepository
import com.cyberacy.app.models.repositories.MessageState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class ThreadViewModel : ViewModel() {

    private val _messages = MutableLiveData<MessageState>()

    val messages = _messages

    init {
        getMessages()
    }

    fun getMessages() {
        viewModelScope.launch {
            MessageRepository.fetchMessages(74).collect {
                _messages.value = it
            }
        }
    }

}