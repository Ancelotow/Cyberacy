package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Round
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException

object RoundRepository {

    suspend fun fetchRound(idVote: Int): Flow<RoundState> {
        return flow {
            emit(RoundStateLoading)
            try {
                emit(RoundStateSuccess(Round.getRounds(idVote)))
            } catch (e: HttpException) {
                emit(RoundStateError(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class RoundState
object RoundStateLoading: RoundState()
data class RoundStateSuccess(val rounds: List<Round>): RoundState()
data class RoundStateError(val ex: HttpException): RoundState()