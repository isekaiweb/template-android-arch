import com.android.build.api.dsl.DynamicFeatureExtension
import com.example.template.configureAndroidCompose
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.apply
import org.gradle.kotlin.dsl.getByType

/**
 * Convention plugin for Compose-enabled library modules within Dynamic Feature Modules (DFMs).
 *
 * Use this for UI modules that use Jetpack Compose within a DFM structure.
 * Apply this plugin AFTER the base DFM plugin.
 *
 * Examples:
 * - request_discount:ui (if using Compose)
 * - Any DFM UI module with Compose dependencies
 *
 * Usage:
 * ```kotlin
 * plugins {
 *     alias(libs.plugins.template.android.library.dynamicfeature)
 *     alias(libs.plugins.template.android.library.compose.dynamicfeature)
 * }
 * ```
 *
 * Note: You can also use the regular template.android.library.compose plugin instead,
 * as it works with DFM modules too. This plugin is provided for consistency
 * with other DFM-specific plugins.
 */
class AndroidLibraryComposeDynamicFeatureConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            // DO NOT apply com.android.dynamic-feature here!
            // It's already applied by template.android.library.dynamicfeature (via AndroidDynamicFeatureConventionPlugin)
            // Applying it twice breaks Hilt annotation processing in DFMs
            apply(plugin = "org.jetbrains.kotlin.plugin.compose")

            val extension = extensions.getByType<DynamicFeatureExtension>()
            configureAndroidCompose(extension)
        }
    }

}

