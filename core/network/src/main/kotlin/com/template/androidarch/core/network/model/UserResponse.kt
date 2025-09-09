package com.template.androidarch.core.network.model

import kotlinx.serialization.Serializable

@Serializable
data class UserResponse(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String? = null
)