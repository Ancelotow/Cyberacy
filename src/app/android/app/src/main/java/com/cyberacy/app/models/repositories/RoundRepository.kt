package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Round
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException
import java.net.ConnectException
import java.net.UnknownHostException

object RoundRepository {

    suspend fun fetchRound(idVote: Int): Flow<RoundState> {
        return flow {
            emit(RoundStateLoading)
            try {
                emit(RoundStateSuccess(Round.getRounds(idVote)))
            } catch (e: HttpException) {
                emit(RoundStateError(e))
            } catch (e: UnknownHostException) {
                emit(RoundStateErrorHost(e))
            } catch (e: ConnectException) {
                emit(RoundStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class RoundState
object RoundStateLoading: RoundState()
data class RoundStateSuccess(val rounds: List<Round>): RoundState()
data class RoundStateError(val ex: HttpException): RoundState()
data class RoundStateErrorHost(val ex: Exception): RoundState()