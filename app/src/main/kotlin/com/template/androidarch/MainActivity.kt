package com.template.androidarch

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.template.androidarch.core.ui.theme.TemplateAndroidArchTheme
import com.template.androidarch.feature.home.presentation.HomeScreen
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            TemplateAndroidArchTheme {
                TemplateApp()
            }
        }
    }
}

@Composable
fun TemplateApp() {
    val navController = rememberNavController()
    
    NavHost(
        navController = navController,
        startDestination = "home"
    ) {
        composable("home") {
            HomeScreen()
        }
        composable("profile") {
            // Profile screen will be implemented in feature:profile module
            androidx.compose.material3.Text(text = "Profile Screen - Template Android Architecture")
        }
    }
}