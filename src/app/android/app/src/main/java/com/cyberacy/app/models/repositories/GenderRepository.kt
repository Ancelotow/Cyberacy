package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Gender
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException

object GenderRepository  {

    suspend fun fetchGender(): Flow<GenderState> {
        return flow {
            emit(GenderStateLoading)
            try {
                emit(GenderStateSuccess(Gender.getGenders()))
            } catch (e: HttpException) {
                emit(GenderStateError(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class GenderState
object GenderStateLoading: GenderState()
data class GenderStateSuccess(val genders: List<Gender>): GenderState()
data class GenderStateError(val ex: HttpException): GenderState()