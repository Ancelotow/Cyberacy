package com.cyberacy.app.models.repositories

import com.cyberacy.app.models.entities.Department
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException
import java.net.UnknownHostException

object DepartmentRepository {

    suspend fun fetchDepartment(): Flow<DepartmentState> {
        return flow {
            emit(DepartmentStateLoading)
            try {
                emit(DepartmentStateSuccess(Department.getDepartment()))
            } catch (e: HttpException) {
                emit(DepartmentStateError(e))
            } catch (e: UnknownHostException) {
                emit(DepartmentStateErrorHost(e))
            }
        }.flowOn(Dispatchers.IO)
    }

}

sealed class DepartmentState
object DepartmentStateLoading: DepartmentState()
data class DepartmentStateSuccess(val departments: List<Department>): DepartmentState()
data class DepartmentStateError(val ex: HttpException): DepartmentState()
data class DepartmentStateErrorHost(val ex: UnknownHostException): DepartmentState()