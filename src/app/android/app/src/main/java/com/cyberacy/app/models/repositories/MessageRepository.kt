package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Message
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException

object MessageRepository {

    suspend fun fetchMessages(id: Int): Flow<MessageState> {
        return flow {
            emit(MessageStateLoading)
            try {
                emit(MessageStateSuccess(Message.getMessages(id)))
            } catch (e: HttpException) {
                emit(MessageStateError(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class MessageState
object MessageStateLoading: MessageState()
data class MessageStateSuccess(val messages: List<Message>): MessageState()
data class MessageStateError(val ex: HttpException): MessageState()