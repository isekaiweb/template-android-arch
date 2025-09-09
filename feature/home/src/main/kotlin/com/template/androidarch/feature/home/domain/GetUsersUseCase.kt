package com.template.androidarch.feature.home.domain

import com.template.androidarch.core.common.domain.Result
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class GetUsersUseCase @Inject constructor(
    private val userRepository: UserRepository
) {
    operator fun invoke(): Flow<Result<List<User>>> {
        return userRepository.getUsers()
    }
}