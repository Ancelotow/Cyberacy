package com.cyberacy.app.ui.meeting.meeting_detail

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.MeetingDetailState
import com.cyberacy.app.models.repositories.MeetingParticipateState
import com.cyberacy.app.models.repositories.MeetingRepository
import kotlinx.coroutines.launch

class MeetingDetailViewModel(private val id: Int) : ViewModel() {

    private val _meeting = MutableLiveData<MeetingDetailState>()
    private val _meetingParticipation = MutableLiveData<MeetingParticipateState>()

    val meeting = _meeting
    val meetingParticipation = _meetingParticipation

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

    fun participateMeeting() {
        viewModelScope.launch {
            MeetingRepository.participateMeeting(id).collect() {
                _meetingParticipation.value = it
            }
        }
    }
}
