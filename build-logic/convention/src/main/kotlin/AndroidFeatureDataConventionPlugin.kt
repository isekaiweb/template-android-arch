import com.android.build.api.dsl.LibraryExtension
import com.example.template.configureGradleManagedDevices
import com.example.template.libs
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.apply
import org.gradle.kotlin.dsl.configure
import org.gradle.kotlin.dsl.dependencies

class AndroidFeatureDataConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            apply(plugin = "template.android.library")
            apply(plugin = "template.hilt")
            apply(plugin = "org.jetbrains.kotlin.plugin.serialization")

            extensions.configure<LibraryExtension> {
                testOptions.animationsDisabled = true
                configureGradleManagedDevices(this)
            }

            dependencies {
                "implementation"(project(":core:network"))
                "implementation"(project(":core:common"))

                "implementation"(libs.findLibrary("retrofit.core").get())
                "implementation"(libs.findLibrary("androidx.tracing.ktx").get())
                "implementation"(libs.findLibrary("kotlinx.serialization.json").get())
                "implementation"(libs.findLibrary("retrofit.kotlin.serialization").get())
            }
        }
    }
}
