# Property Management System — Module 1: App Initialization

Flutter 3.44.4 / Dart 3.x · Clean Architecture · Feature-first · Riverpod · GoRouter

## Layers

```
lib/
  core/                      # shared across every future module
    constants/               # app + asset constants
    di/                      # Riverpod provider wiring (core services)
    error/                   # Failure (domain) + Exception (data) types
    network/                 # Dio client, API-ready
    router/                  # GoRouter + Route Guard
    services/                # Logger, Connectivity, SecureStorage, Hive
    theme/                   # Colors, TextStyles, ThemeData
    utils/                   # Result<T> (Either-style, no dartz needed)
    widgets/                 # PlaceholderPage (stub for unbuilt routes)

  features/splash/
    domain/                  # AuthSession, AppDestination, AuthRepository (abstract), UseCase
    data/                    # AuthSessionModel (Freezed), Local/RemoteDataSource, RepositoryImpl
    presentation/            # SplashPage, SplashLogo, Riverpod providers
```

Dependency direction is strictly `presentation -> domain <- data`. The
Presentation layer never imports anything from `data/`.

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates *.freezed.dart / *.g.dart
flutter run
```

## Notes

- `LocalStorageService.init()` (Hive) runs in `main.dart` **before**
  `runApp`, and its instance is injected into the Riverpod tree via
  `ProviderContainer(overrides: [...])` — providers can't `await`
  inside their own body, so this is the standard pattern for
  async-initialized singletons.
- Sensitive data (tokens) live only in `flutter_secure_storage`.
  Non-sensitive app state (login flag, cached profile JSON, onboarding
  flag) lives in Hive. Never mix the two.
- `Login` and `Home` are rendered by a shared `PlaceholderPage` until
  their real modules are built — only `app_router.dart` needs to change
  when that happens.
