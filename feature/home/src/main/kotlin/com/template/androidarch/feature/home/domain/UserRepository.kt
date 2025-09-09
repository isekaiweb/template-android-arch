package com.template.androidarch.feature.home.domain

import com.template.androidarch.core.common.domain.Result
import kotlinx.coroutines.flow.Flow

interface UserRepository {
    fun getUsers(): Flow<Result<List<User>>>
    suspend fun refreshUsers(): Result<Unit>
}