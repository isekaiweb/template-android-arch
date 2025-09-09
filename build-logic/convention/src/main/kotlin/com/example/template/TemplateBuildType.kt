package com.example.template

/**
 * This is shared between :app and :benchmarks module to provide configurations type safety.
 */
enum class TemplateBuildType(val applicationIdSuffix: String? = null) {
    DEBUG(".debug"),
    RELEASE,
}
