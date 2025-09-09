package com.template.androidarch.core.network.api

import com.template.androidarch.core.network.model.UserResponse
import retrofit2.http.GET
import retrofit2.http.Path

/**
 * API service interface defining network endpoints
 */
interface ApiService {
    
    @GET("users/{id}")
    suspend fun getUser(@Path("id") userId: String): UserResponse
    
    @GET("users")
    suspend fun getUsers(): List<UserResponse>
}