import com.android.build.api.variant.BuildConfigField
import org.gradle.api.Project
import org.gradle.api.provider.Provider
import java.io.StringReader
import java.util.Properties

/**
 * Extension functions for reading properties from local.properties and creating BuildConfig fields.
 * These functions are available to all modules that apply the network convention plugin.
 */

/**
 * Reads a property value from local.properties file.
 * @param key The property key to read
 * @param defaultValue The default value if property is not found
 * @return Provider<String> containing the property value
 */
private fun Project.readPropertyFromLocalProperties(key: String, defaultValue: String = "http://example.com"): Provider<String> =
    providers.fileContents(
        isolated.rootProject.projectDirectory.file("local.properties")
    ).asText.map { text ->
        val properties = Properties()
        properties.load(StringReader(text))
        properties[key] as? String ?: defaultValue
    }

/**
 * Creates a BuildConfigField from a property provider.
 * @param propertyProvider The provider containing the property value
 * @return Provider<BuildConfigField> for use in androidComponents
 */
private fun createBuildConfigField(propertyProvider: Provider<String>): Provider<BuildConfigField<String>> =
    propertyProvider.map { value ->
        BuildConfigField(type = "String", value = """"$value"""", comment = null)
    }

/**
 * Convenience function to read a property and create a BuildConfig field in one step.
 * @param key The property key to read
 * @param defaultValue The default value if property is not found
 * @return Provider<BuildConfigField> ready for use in androidComponents
 */
fun Project.createBuildConfigFieldFromProperty(key: String, defaultValue: String = "http://example.com"): Provider<BuildConfigField<String>> =
    createBuildConfigField(readPropertyFromLocalProperties(key, defaultValue))
