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

1. Clone this branch

```
git clone https://github.com/isekaiweb/template-android-arch.git
```

2. Run the customizer script:

```
./customizer.sh com.example.template DataItemType [MyApplication]
```

Where `your.package.name` is your app ID (should be lowercase) and `DataItemType` is used for the
name of the screen, exposed state and data base entity (should be PascalCase). You can add an optional application name.

# License

Now in Android is distributed under the terms of the Apache License (Version 2.0). See the
[license](LICENSE) for more information.