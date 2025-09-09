package com.template.androidarch.feature.home.domain

data class User(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String? = null
)