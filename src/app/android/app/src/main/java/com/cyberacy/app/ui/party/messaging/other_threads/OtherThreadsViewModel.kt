package com.cyberacy.app.ui.party.messaging.other_threads

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.ThreadRepository
import com.cyberacy.app.models.repositories.ThreadState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class OtherThreadsViewModel : ViewModel() {

    private val _threads = MutableLiveData<ThreadState>()

    val otherThreads = _threads

    init {
        getThreads()
    }

    fun getThreads() {
        viewModelScope.launch {
            ThreadRepository.fetchOtherThread().collect {
                _threads.value = it
            }
        }
    }

}