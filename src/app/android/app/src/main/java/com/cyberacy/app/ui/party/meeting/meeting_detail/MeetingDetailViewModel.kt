package com.cyberacy.app.ui.party.meeting.meeting_detail

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.MeetingRepository
import com.cyberacy.app.models.repositories.MeetingState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class MeetingDetailViewModel(private val id: Int) : ViewModel() {

    private val _meeting = MutableLiveData<MeetingState>()
    val meeting = _meeting

    class Factory(private val id: Int) : ViewModelProvider.Factory {

        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return MeetingDetailViewModel(id) as T
        }

    }

    init {
        getMeeting()
    }

    fun getMeeting() {
        viewModelScope.launch {
            MeetingRepository.fetchMeetingById(id).collect {
                _meeting.value = it
            }
        }
    }
}
