package com.cyberacy.app.ui.party.messaging.my_threads

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.ThreadRepository
import com.cyberacy.app.models.repositories.ThreadState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class MyThreadViewModel : ViewModel() {

    private val _threads = MutableLiveData<ThreadState>()

    val myThreads = _threads

    init {
        getThreads()
    }

    fun getThreads() {
        viewModelScope.launch {
            ThreadRepository.fetchMyThread().collect {
                _threads.value = it
            }
        }
    }

}