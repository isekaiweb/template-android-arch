Architecture starter template (multi-module)
==================

This template is based on [NowInAndroid](https://github.com/android/nowinandroid) project.

    
## Features

* Room Database
* Hilt
* ViewModel, read+write
* UI in Compose, list + write (Material3)
* Navigation
* Repository and data source
* Kotlin Coroutines and Flow
* Unit tests
* UI tests using fake data with Hilt

## Usage

1. Clone the repository, optionally choosing a branch and a target directory. For example, to check out the base branch:

```
git clone https://github.com/isekaiweb/template-android-arch.git --branch main targetDirectory
```
For the customizer to work, dont open the project in Android Studio yet.
2. Run the customizer script:

```
./customizer.sh com.example.template DataItemType [MyApplication]
```

* `your.package.name` is your app ID (should be lowercase)
* `DataItemType` is used for the name of the screen, exposed state and data base entity
  (should be PascalCase).
* Optionally, you can specify a name for your application (should be in PascalCase).
