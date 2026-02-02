plugins {
    alias(libs.plugins.template.android.library)
//    alias(libs.plugins.template.android.library.jacoco)
    alias(libs.plugins.template.hilt)
    id("kotlinx-serialization")
}

android {
    buildFeatures {
        buildConfig = true
    }
    namespace = "com.example.template.core.network"
    testOptions.unitTests.isIncludeAndroidResources = true
}

dependencies {
    api(libs.kotlinx.datetime)

    implementation(libs.coil.kt)
    implementation(libs.coil.kt.svg)
    implementation(libs.kotlinx.serialization.json)
    implementation(libs.okhttp.logging)
    implementation(libs.retrofit.core)
    implementation(libs.retrofit.kotlin.serialization)

    testImplementation(libs.kotlinx.coroutines.test)
}

// Read properties using shared extension functions
androidComponents {
    onVariants { variant ->
        variant.buildConfigFields?.put(
            "BACKEND_URL",
            createBuildConfigFieldFromProperty("SFA_BACKEND_URL"),
        )
        variant.buildConfigFields?.put(
            "SECRET_TOKEN",
            createBuildConfigFieldFromProperty("SECRET_TOKEN", "default_token"),
        )
    }
}
