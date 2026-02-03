import com.android.build.gradle.api.AndroidBasePlugin
import com.example.template.libs
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.apply
import org.gradle.kotlin.dsl.dependencies

class HiltConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            apply(plugin = "com.google.devtools.ksp")

            dependencies {
                "ksp"(libs.findLibrary("hilt.compiler").get())
            }

            // Add support for Jvm Module, base on org.jetbrains.kotlin.jvm
            pluginManager.withPlugin("org.jetbrains.kotlin.jvm") {
                dependencies {
                    "implementation"(libs.findLibrary("hilt.core").get())
                }
            }

            /** Add support for Android modules, based on [AndroidBasePlugin] */
            pluginManager.withPlugin("com.android.base") {
                // Always add Hilt dependencies (all Android modules need these)
                dependencies {
                    "implementation"(libs.findLibrary("hilt.android").get())
                }

                // Apply Hilt Android plugin for supported module types
                pluginManager.withPlugin("com.android.application") {
                    apply(plugin = "dagger.hilt.android.plugin")
                }

                pluginManager.withPlugin("com.android.library") {
                    apply(plugin = "dagger.hilt.android.plugin")
                }

                // Dynamic Feature Modules: do NOT apply Hilt plugin; they are aggregated by the base app
            }
        }
    }
}
