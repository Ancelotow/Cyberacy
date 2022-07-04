package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.ThreadMessaging
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException

object ThreadRepository {

    suspend fun fetchMyThread(): Flow<ThreadState> {
        return flow {
            emit(ThreadStateLoading)
            try {
                emit(ThreadStateSuccess(ThreadMessaging.getMyThreads()))
            } catch (e: HttpException) {
                emit(ThreadStateError(e))
            }
        }.flowOn(Dispatchers.IO)
    }

    suspend fun fetchOtherThread(): Flow<ThreadState> {
        return flow {
            emit(ThreadStateLoading)
            try {
                emit(ThreadStateSuccess(ThreadMessaging.getOtherThreads()))
            } catch (e: HttpException) {
                emit(ThreadStateError(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class ThreadState
object ThreadStateLoading: ThreadState()
data class ThreadStateSuccess(val threads: List<ThreadMessaging>): ThreadState()
data class ThreadStateError(val ex: HttpException): ThreadState()