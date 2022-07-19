package com.cyberacy.app.models.repositories

import android.util.Log
import com.cyberacy.app.models.entities.Message
import com.cyberacy.app.models.entities.PoliticalParty
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.isActive
import retrofit2.HttpException
import java.net.UnknownHostException

object PoliticalPartyRepository {

    suspend fun fetchPoliticalParties(): Flow<PartyState> {
        return flow {
            emit(PartyStateLoading)
            try {
                emit(PartyStateSuccessList(PoliticalParty.getPoliticalParties()))
            } catch (e: HttpException) {
                emit(PartyStateError(e))
            } catch (e: UnknownHostException) {
                emit(PartyStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

    suspend fun fetchMineParty(): Flow<PartyState> {
        return flow {
            emit(PartyStateLoading)
            try {
                emit(PartyStateSuccessMine(PoliticalParty.getMinePoliticalParty()))
            } catch (e: HttpException) {
                emit(PartyStateError(e))
            } catch (e: UnknownHostException) {
                emit(PartyStateErrorHost(e))
            }
        }
    }

    suspend fun fetchPartyById(id: Int): Flow<PartyState> {
        return flow {
            emit(PartyStateLoading)
            try {
                emit(PartyStateSuccessMine(PoliticalParty.getPoliticalPartyById(id)))
            } catch (e: HttpException) {
                emit(PartyStateError(e))
            } catch (e: UnknownHostException) {
                emit(PartyStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class PartyState
object PartyStateLoading: PartyState()
data class PartyStateSuccessList(val parties: List<PoliticalParty>): PartyState()
data class PartyStateSuccessMine(val party: PoliticalParty?): PartyState()
data class PartyStateError(val ex: HttpException): PartyState()
data class PartyStateErrorHost(val ex: UnknownHostException): PartyState()