package com.cyberacy.app.ui.meeting.meeting_ticket

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.MeetingQRCodeState
import com.cyberacy.app.models.repositories.MeetingRepository
import kotlinx.coroutines.launch

class MeetingTicketViewModel(private val id: Int) : ViewModel() {

    private val _meetingQrcode = MutableLiveData<MeetingQRCodeState>()
    val meetingQrcode = _meetingQrcode

    class Factory(private val id: Int) : ViewModelProvider.Factory {

        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return MeetingTicketViewModel(id) as T
        }

    }

    init {
        getInfoQrcode()
    }

    private fun getInfoQrcode() {
        viewModelScope.launch {
            MeetingRepository.fetchMeetingQRCode(id).collect {
                _meetingQrcode.value = it
            }
        }
    }

}