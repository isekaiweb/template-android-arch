package com.template.androidarch.core.database

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.template.androidarch.core.database.dao.UserDao
import com.template.androidarch.core.database.entity.UserEntity

@Database(
    entities = [UserEntity::class],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao
}