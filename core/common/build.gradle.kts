plugins {
    alias(libs.plugins.template.jvm.library)
    alias(libs.plugins.template.hilt)
}

dependencies {
    implementation(libs.kotlinx.coroutines.core)
//    testImplementation(libs.kotlinx.coroutines.test)
//    testImplementation(libs.turbine)
}