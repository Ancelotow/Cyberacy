package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.PoliticalParty
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException

object PoliticalPartyRepository {

    suspend fun fetchPoliticalParties(): Flow<PartyState> {
        return flow {
            emit(PartyStateLoading)
            try {
                emit(PartyStateSuccessList(PoliticalParty.getPoliticalParties()))
            } catch (e: HttpException) {
                emit(PartyStateError(e))
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
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class PartyState
object PartyStateLoading: PartyState()
data class PartyStateSuccessList(val parties: List<PoliticalParty>): PartyState()
data class PartyStateSuccessMine(val party: PoliticalParty?): PartyState()
data class PartyStateError(val ex: HttpException): PartyState()