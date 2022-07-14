package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Vote
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException

object VoteRepository {

    suspend fun fetchVoteInProgress(): Flow<VoteState> {
        return flow {
            emit(VoteStateLoading)
            try {
                emit(VoteStateSuccess(Vote.getVoteInProgress()))
            } catch (e: HttpException) {
                emit(VoteStateError(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}


sealed class VoteState
object VoteStateLoading: VoteState()
data class VoteStateSuccess(val votes: List<Vote>): VoteState()
data class VoteStateError(val ex: HttpException): VoteState()