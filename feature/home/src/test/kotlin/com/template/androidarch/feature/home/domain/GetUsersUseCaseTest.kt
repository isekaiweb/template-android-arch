package com.template.androidarch.feature.home.domain

import com.template.androidarch.core.common.domain.Result
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.test.runTest
import org.junit.Test
import org.junit.Assert.*

class GetUsersUseCaseTest {

    @Test
    fun `invoke should return users from repository`() = runTest {
        // Given
        val users = listOf(
            User(id = "1", name = "John Doe", email = "john@example.com"),
            User(id = "2", name = "Jane Doe", email = "jane@example.com")
        )
        val mockRepository = object : UserRepository {
            override fun getUsers() = flowOf(Result.Success(users))
            override suspend fun refreshUsers() = Result.Success(Unit)
        }
        
        val useCase = GetUsersUseCase(mockRepository)

        // When
        val result = useCase().toList().first()

        // Then
        assertTrue(result is Result.Success)
        val successResult = result as Result.Success
        assertEquals(2, successResult.data.size)
        assertEquals("John Doe", successResult.data[0].name)
        assertEquals("Jane Doe", successResult.data[1].name)
    }
}