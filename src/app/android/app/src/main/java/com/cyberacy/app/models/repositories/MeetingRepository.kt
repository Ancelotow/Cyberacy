package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Meeting
import com.cyberacy.app.models.entities.MeetingQrCode
import com.cyberacy.app.models.entities.PoliticalParty
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException
import java.net.UnknownHostException

object MeetingRepository {

    suspend fun fetchMeetings(partyId: Int): Flow<MeetingListState> {
        return flow {
            emit(MeetingListStateLoading)
            try {
                emit(MeetingListStateSuccess(Meeting.getMeetings(partyId)))
            } catch (e: HttpException) {
                emit(MeetingListStateError(e))
            } catch (e: UnknownHostException) {
                emit(MeetingListStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

    suspend fun fetchMeetingById(id: Int): Flow<MeetingDetailState> {
        return flow {
            emit(MeetingDetailStateLoading)
            try {
                emit(MeetingDetailStateSuccess(Meeting.getMeetingById(id)))
            } catch (e: HttpException) {
                emit(MeetingDetailStateError(e))
            } catch (e: UnknownHostException) {
                emit(MeetingDetailStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

    suspend fun participateMeeting(id: Int): Flow<MeetingParticipateState> {
        return flow {
            emit(MeetingParticipateStateLoading)
            try {
                emit(MeetingParticipateStateSuccess(Meeting.participatedToMeeting(id)))
            } catch (e: HttpException) {
                emit(MeetingParticipateStateError(e))
            } catch (e: UnknownHostException) {
                emit(MeetingParticipateStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

    suspend fun fetchMeetingQRCode(id: Int): Flow<MeetingQRCodeState> {
        return flow {
            emit(MeetingQRCodeStateLoading)
            try {
                emit(MeetingQRCodeStateSuccess(MeetingQrCode.getMeetingsQRCode(id)))
            } catch (e: HttpException) {
                emit(MeetingQRCodeStateError(e))
            } catch (e: UnknownHostException) {
                emit(MeetingQRCodeStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

// List of Meeting
sealed class MeetingListState
object MeetingListStateLoading: MeetingListState()
data class MeetingListStateSuccess(val meetings: List<Meeting>): MeetingListState()
data class MeetingListStateError(val ex: HttpException): MeetingListState()
data class MeetingListStateErrorHost(val ex: UnknownHostException): MeetingListState()

// Details of Meeting
sealed class MeetingDetailState
object MeetingDetailStateLoading: MeetingDetailState()
data class MeetingDetailStateSuccess(val meeting: Meeting?): MeetingDetailState()
data class MeetingDetailStateError(val ex: HttpException): MeetingDetailState()
data class MeetingDetailStateErrorHost(val ex: UnknownHostException): MeetingDetailState()

// Participated to a Meeting
sealed class MeetingParticipateState
object MeetingParticipateStateLoading: MeetingParticipateState()
data class MeetingParticipateStateSuccess(val response: Unit): MeetingParticipateState()
data class MeetingParticipateStateError(val ex: HttpException): MeetingParticipateState()
data class MeetingParticipateStateErrorHost(val ex: UnknownHostException): MeetingParticipateState()

// QR-Code of a Meeting
sealed class MeetingQRCodeState
object MeetingQRCodeStateLoading: MeetingQRCodeState()
data class MeetingQRCodeStateSuccess(val meetingQrcode: MeetingQrCode?): MeetingQRCodeState()
data class MeetingQRCodeStateError(val ex: HttpException): MeetingQRCodeState()
data class MeetingQRCodeStateErrorHost(val ex: UnknownHostException): MeetingQRCodeState()