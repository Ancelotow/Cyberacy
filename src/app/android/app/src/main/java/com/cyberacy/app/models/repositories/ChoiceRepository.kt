package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Choice
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException
import java.net.ConnectException
import java.net.UnknownHostException

object ChoiceRepository {

    suspend fun fetchChoice(idVote: Int, idRound: Int): Flow<ChoiceState> {
        return flow {
            emit(ChoiceStateLoading)
            try {
                emit(ChoiceStateSuccess(Choice.getChoices(idVote, idRound)))
            } catch (e: HttpException) {
                emit(ChoiceStateError(e))
            } catch (e: UnknownHostException) {
                emit(ChoiceStateErrorHost(e))
            } catch (e: ConnectException) {
                emit(ChoiceStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class ChoiceState
object ChoiceStateLoading: ChoiceState()
data class ChoiceStateSuccess(val choices: List<Choice>): ChoiceState()
data class ChoiceStateError(val ex: HttpException): ChoiceState()
data class ChoiceStateErrorHost(val ex: Exception): ChoiceState()