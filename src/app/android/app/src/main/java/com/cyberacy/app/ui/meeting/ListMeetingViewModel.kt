package com.cyberacy.app.ui.meeting

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.cyberacy.app.models.repositories.MeetingListState
import com.cyberacy.app.models.repositories.MeetingRepository
import kotlinx.coroutines.launch

class ListMeetingViewModel(private val idParty: Int) : ViewModel() {

    private val _meetings = MutableLiveData<MeetingListState>()
    val listMeetings = _meetings

    class Factory(private val idParty: Int) : ViewModelProvider.Factory {

        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return ListMeetingViewModel(idParty) as T
        }

    }

    init {
        getAllMeetings()
    }

    fun getAllMeetings() {
        viewModelScope.launch {
            MeetingRepository.fetchMeetings(idParty).collect {
                _meetings.value = it
            }
        }
    }

}