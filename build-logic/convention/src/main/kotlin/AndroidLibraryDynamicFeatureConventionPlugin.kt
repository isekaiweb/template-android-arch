import com.android.build.api.dsl.DynamicFeatureExtension
import com.android.build.api.variant.DynamicFeatureAndroidComponentsExtension
import com.example.template.configureFlavors
import com.example.template.configureGradleManagedDevices
import com.example.template.configureKotlinAndroid
import com.example.template.configurePrintApksTask
import com.example.template.disableUnnecessaryAndroidTests
import com.example.template.libs
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.apply
import org.gradle.kotlin.dsl.configure
import org.gradle.kotlin.dsl.dependencies

/**
 * Convention plugin for library-style dynamic feature modules.
 *
 * Use this for data, domain, and UI (non-Compose) modules within a DFM.
 * Similar to AndroidLibraryConventionPlugin but for dynamic features.
 *
 * Examples:
 * - request_discount:data
 * - request_discount:domain
 * - request_discount:ui (if not using Compose)
 */
class AndroidLibraryDynamicFeatureConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            apply(plugin = "com.android.dynamic-feature")
            apply(plugin = "org.jetbrains.kotlin.android")
            apply(plugin = "template.android.lint")

            extensions.configure<DynamicFeatureExtension> {
                configureKotlinAndroid(this)
                lint.targetSdk = 35
                defaultConfig.testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
                testOptions.animationsDisabled = true
                configureFlavors(this)
                configureGradleManagedDevices(this)
                // The resource prefix is derived from the module name,
                // so resources inside ":core:module1" must be prefixed with "core_module1_"
                resourcePrefix =
                    path.split("""\W""".toRegex()).drop(1).distinct().joinToString(separator = "_")
                        .lowercase() + "_"
            }

            extensions.configure<DynamicFeatureAndroidComponentsExtension> {
                configurePrintApksTask(this)
                disableUnnecessaryAndroidTests(target)
            }

            dependencies {
                // Required: All dynamic feature modules must depend on the app module
                // This is an Android requirement for DFMs to work properly
                "implementation"(project(":app"))

                "implementation"(libs.findLibrary("timber").get())
                "androidTestImplementation"(libs.findLibrary("kotlin.test").get())
                "testImplementation"(libs.findLibrary("kotlin.test").get())

                "implementation"(libs.findLibrary("androidx.tracing.ktx").get())
            }
        }
    }
}

