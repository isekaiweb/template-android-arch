plugins {
    alias(libs.plugins.template.android.library)
    alias(libs.plugins.template.android.library.compose)
//    alias(libs.plugins.template.android.library.jacoco)
}

android {
    namespace = "com.example.template.presentation.ui"
}

dependencies {
    api(libs.androidx.metrics)
    api(projects.core.presentation.designsystem)

    implementation(libs.androidx.browser)
    implementation(libs.coil.kt)
    implementation(libs.coil.kt.compose)

    androidTestImplementation(libs.bundles.androidx.compose.ui.test)
}
