package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Meeting
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException

object MeetingRepository {

    suspend fun fetchMeetings(id: Int): Flow<MeetingState> {
        return flow {
            emit(MeetingStateLoading)
            try {
                emit(MeetingStateSuccess(Meeting.getMeetings(id)))
            } catch (e: HttpException) {
                emit(MeetingStateError(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class MeetingState
object MeetingStateLoading: MeetingState()
data class MeetingStateSuccess(val meetings: List<Meeting>): MeetingState()
data class MeetingStateError(val ex: HttpException): MeetingState()