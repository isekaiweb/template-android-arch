package com.template.androidarch.feature.home.data

import com.template.androidarch.core.common.domain.Result
import com.template.androidarch.core.database.dao.UserDao
import com.template.androidarch.core.database.entity.UserEntity
import com.template.androidarch.core.network.api.ApiService
import com.template.androidarch.core.network.model.UserResponse
import com.template.androidarch.feature.home.domain.User
import com.template.androidarch.feature.home.domain.UserRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class UserRepositoryImpl @Inject constructor(
    private val apiService: ApiService,
    private val userDao: UserDao
) : UserRepository {

    override fun getUsers(): Flow<Result<List<User>>> {
        return userDao.getAllUsers().map { userEntities ->
            Result.Success(userEntities.map { it.toDomainModel() })
        }
    }

    override suspend fun refreshUsers(): Result<Unit> {
        return try {
            val users = apiService.getUsers()
            userDao.insertUsers(users.map { it.toEntity() })
            Result.Success(Unit)
        } catch (e: Exception) {
            Result.Error(e)
        }
    }
}

private fun UserEntity.toDomainModel(): User {
    return User(
        id = id,
        name = name,
        email = email,
        avatarUrl = avatarUrl
    )
}

private fun UserResponse.toEntity(): UserEntity {
    return UserEntity(
        id = id,
        name = name,
        email = email,
        avatarUrl = avatarUrl
    )
}