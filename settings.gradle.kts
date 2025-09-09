pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "TemplateAndroidArch"

include(":app")
include(":core:common")
include(":core:network")
include(":core:database")
include(":core:ui")
include(":feature:home")
include(":feature:profile")