# Template Android Architecture

A modern Android application template featuring multi-module architecture and Modern Android Development (MAD) practices.

## 🏗️ Architecture Overview

This project implements a **multi-module, clean architecture** pattern with separation of concerns across different layers:

### Module Structure

```
├── app/                          # Main application module
├── core/
│   ├── common/                   # Common utilities and base classes
│   ├── network/                  # Network layer (Retrofit, OkHttp)
│   ├── database/                 # Local database (Room)
│   └── ui/                       # UI components and theme
├── feature/
│   ├── home/                     # Home feature module
│   └── profile/                  # Profile feature module
```

### Architecture Layers

- **Presentation Layer**: UI components, ViewModels, Compose screens
- **Domain Layer**: Business logic, use cases, repository interfaces
- **Data Layer**: Repository implementations, data sources, mappers

## 🚀 Modern Android Development Stack

This template includes the latest Android development tools and libraries:

### Core Technologies
- **Kotlin** - Primary language
- **Jetpack Compose** - Modern UI toolkit
- **Material Design 3** - UI components and theming
- **Navigation Compose** - Type-safe navigation

### Architecture Components
- **ViewModel** - UI state management
- **StateFlow** - Reactive state management
- **Coroutines** - Asynchronous programming

### Dependency Injection
- **Hilt** - Dependency injection framework
- **KSP** - Symbol processing for code generation

### Data Management
- **Room** - Local database
- **Retrofit** - REST API client
- **OkHttp** - HTTP client
- **Kotlinx Serialization** - JSON serialization

## 📱 Features Demonstrated

### Home Feature
- MVVM architecture pattern
- Repository pattern with local and remote data sources
- Use case pattern for business logic
- Reactive UI with Compose and StateFlow
- Error handling and loading states

### Profile Feature
- Simple feature module structure
- Compose-based UI

## 🛠️ Setup Instructions

### Prerequisites
- Android Studio Hedgehog (2023.1.1) or later
- JDK 17 or higher
- Android SDK with API level 24+

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/isekaiweb/template-android-arch.git
   cd template-android-arch
   ```

2. **Open in Android Studio**
   - Launch Android Studio
   - Click "Open" and select the project directory
   - Wait for Gradle sync to complete

3. **Build and Run**
   ```bash
   ./gradlew assembleDebug
   ```

### Configuration

1. **Update Base URL**: Update the API base URL in `NetworkModule.kt`:
   ```kotlin
   .baseUrl("https://your-api.com/")
   ```

2. **App ID**: Modify the application ID in `app/build.gradle.kts`:
   ```kotlin
   applicationId = "your.package.name"
   ```

## 📦 Module Dependencies

### Dependency Graph
```
app
├── feature:home
├── feature:profile
├── core:ui
├── core:network
├── core:database
└── core:common

feature:home
├── core:common
├── core:ui
├── core:network
└── core:database

feature:profile
├── core:common
└── core:ui
```

## 🏛️ Architecture Principles

### Clean Architecture
- **Separation of Concerns**: Each module has a single responsibility
- **Dependency Inversion**: Higher-level modules don't depend on lower-level modules
- **Testability**: Easy to unit test each layer independently

### SOLID Principles
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Objects can be replaced with instances of their subtypes
- **Interface Segregation**: Clients shouldn't depend on interfaces they don't use
- **Dependency Inversion**: Depend on abstractions, not concretions

## 🧪 Testing Strategy

### Unit Testing
- Repository implementations
- Use cases/Interactors
- ViewModels
- Utility functions

### Integration Testing
- Database operations
- Network requests
- Repository contracts

### UI Testing
- Compose screen tests
- Navigation tests
- User interaction tests

## 📋 Code Style

### Kotlin Conventions
- Follow [official Kotlin coding conventions](https://kotlinlang.org/docs/coding-conventions.html)
- Use meaningful names for classes, functions, and variables
- Prefer `val` over `var` when possible
- Use trailing commas in multi-line constructs

### Architecture Conventions
- Keep ViewModels Android-agnostic
- Use sealed classes for representing states
- Implement repository pattern for data access
- Use dependency injection for loose coupling

## 🔧 Development Tools

### Build Tools
- **Gradle** with Kotlin DSL
- **Version Catalog** for dependency management
- **KSP** for annotation processing

### Code Quality
- **Kotlin compiler** with strict warnings
- **ProGuard** for release builds
- Built-in **lint** checks

## 🚦 Next Steps

### Extending the Template

1. **Add New Features**:
   - Create new feature modules under `feature/`
   - Follow the established architecture patterns
   - Add navigation routes and dependency injection

2. **Enhance Core Modules**:
   - Add authentication to `core:network`
   - Extend database entities in `core:database`
   - Add custom UI components to `core:ui`

3. **Add Testing**:
   - Unit tests for business logic
   - Integration tests for data layer
   - UI tests for user flows

### Advanced Features
- **Offline Support**: Implement data synchronization
- **Push Notifications**: Add FCM integration
- **Analytics**: Integrate tracking and monitoring
- **CI/CD**: Set up automated builds and deployments

## 📚 Learning Resources

- [Android Architecture Guide](https://developer.android.com/topic/architecture)
- [Jetpack Compose Documentation](https://developer.android.com/jetpack/compose)
- [Hilt Dependency Injection](https://dagger.dev/hilt/)
- [Room Database](https://developer.android.com/topic/libraries/architecture/room)
- [Kotlin Coroutines Guide](https://kotlinlang.org/docs/coroutines-guide.html)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes following the established patterns
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.