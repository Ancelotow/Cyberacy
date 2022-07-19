package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Manifestation
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException
import java.net.ConnectException
import java.net.UnknownHostException

object ManifestationRepository {

    suspend fun fetchManifestations(): Flow<ManifestationDetailState> {
        return flow {
            emit(ManifestationStateLoading)
            try {
                emit(ManifestationStateSuccess(Manifestation.getManifestation()))
            } catch (e: HttpException) {
                emit(ManifestationStateError(e))
            }catch (e: ConnectException) {
                emit(ManifestationStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }


}


sealed class ManifestationDetailState
object ManifestationStateLoading: ManifestationDetailState()
data class ManifestationStateSuccess(val manifestation: List<Manifestation>): ManifestationDetailState()
data class ManifestationStateErrorHost(val ex: ConnectException): ManifestationDetailState()
data class ManifestationStateError(val ex: Exception): ManifestationDetailState()