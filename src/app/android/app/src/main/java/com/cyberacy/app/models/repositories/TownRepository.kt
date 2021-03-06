package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Town
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException
import java.net.ConnectException
import java.net.UnknownHostException

object TownRepository {

    suspend fun fetchTownFromDepartment(codeDept: String): Flow<TownState> {
        return flow {
            emit(TownStateLoading)
            try {
                emit(TownStateSuccess(Town.getTownsFromDept(codeDept)))
            } catch (e: HttpException) {
                emit(TownStateError(e))
            } catch (e: UnknownHostException) {
                emit(TownStateErrorHost(e))
            } catch (e: ConnectException) {
                emit(TownStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}


sealed class TownState
object TownStateLoading: TownState()
data class TownStateSuccess(val towns: List<Town>): TownState()
data class TownStateError(val ex: HttpException): TownState()
data class TownStateErrorHost(val ex: Exception): TownState()