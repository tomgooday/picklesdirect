# Development Setup

> Quick-start guide for engineers picking up the project.

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter SDK | ≥ 3.9.2 | https://docs.flutter.dev/get-started/install |
| Dart | ≥ 3.0 (bundled with Flutter) | — |
| Xcode | ≥ 15 | Mac App Store |
| Android Studio | Hedgehog or later | https://developer.android.com/studio |
| CocoaPods | Latest | `sudo gem install cocoapods` |
| Node.js | ≥ 18 (for Firebase CLI) | https://nodejs.org |
| Firebase CLI | Latest | `npm install -g firebase-tools` |
| FlutterFire CLI | Latest | `dart pub global activate flutterfire_cli` |

---

## First-time Setup

```bash
# 1. Navigate to the Flutter project
cd "Pickles Direct MVP/pickles_direct"

# 2. Fetch dependencies
flutter pub get

# 3. Run code generators (Drift, Injectable, Freezed)
dart run build_runner build --delete-conflicting-outputs

# 4. Verify everything is clean
flutter analyze
flutter test
```

---

## Running the App

### iOS Simulator

```bash
flutter run --dart-define=MIDDLEWARE_BASE_URL=https://api-dev.picklesdirect.com.au
```

### Android Emulator

```bash
flutter run --dart-define=MIDDLEWARE_BASE_URL=https://api-dev.picklesdirect.com.au
```

### Web (PWA)

```bash
flutter run -d chrome --dart-define=MIDDLEWARE_BASE_URL=https://api-dev.picklesdirect.com.au
```

### Available `--dart-define` keys

| Key | Default | Notes |
|-----|---------|-------|
| `MIDDLEWARE_BASE_URL` | `https://api.picklesdirect.com.au` | Override for dev/staging |
| `ENVIRONMENT` | `development` | `development` / `staging` / `production` |
| `AZURE_CLIENT_ID` | `""` | Azure Entra client ID (SSO disabled when empty) |
| `AZURE_TENANT_ID` | `""` | Azure Entra tenant ID |

---

## Project Structure Quick Reference

```
pickles_direct/
├── lib/
│   ├── core/        # Shared infrastructure (theme, router, DI, DB, network)
│   ├── features/    # One folder per feature (auth, bulk_lead_capture, dashboard, …)
│   └── main.dart
├── test/
│   ├── features/    # Feature unit tests
│   └── helpers/     # Shared test helpers + mock declarations
├── docs/            # ← You are here
│   ├── ARCHITECTURE.md
│   ├── PROGRESS.md
│   ├── DEVELOPMENT_SETUP.md   (this file)
│   ├── EXTERNAL_DEPENDENCIES.md
│   └── features/
│       ├── auth.md
│       └── bulk-lead-capture.md
├── .github/
│   └── workflows/ci.yml
├── analysis_options.yaml
├── pubspec.yaml
└── sonar-project.properties
```

---

## Regenerating Code

Run this after any of the following:
- Adding/modifying a `@injectable`, `@singleton`, or `@lazySingleton` annotation
- Adding/altering a Drift `Table` class
- Adding a `@freezed` or `@JsonSerializable` annotation

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Running Tests

```bash
# All tests
flutter test

# Specific feature
flutter test test/features/auth/

# With coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Adding a New Feature

Follow this checklist for any new feature module:

1. **Create folder structure:**
   ```
   lib/features/<feature_name>/
   ├── domain/
   │   ├── entities/<entity>.dart
   │   └── repositories/<feature>_repository.dart
   ├── data/
   │   ├── datasources/<feature>_api.dart      (when middleware spec available)
   │   └── repositories/<feature>_repository_impl.dart
   └── presentation/
       ├── bloc/<feature>_bloc.dart
       ├── pages/<feature>_page.dart
       └── widgets/
   ```

2. **Define the domain entity** — pure Dart class, `extends Equatable`, no Flutter deps.

3. **Define the repository interface** — methods return `Future<Either<Failure, T>>`.

4. **Create the Bloc** — annotate with `@injectable`, register events in constructor.

5. **Add route(s)** to `Routes` constants and `app_router.dart`.

6. **Annotate DI** and re-run `build_runner`.

7. **Write Bloc unit tests** before building the UI.

8. **Build the page(s)** using `BlocProvider` + `BlocBuilder` / `BlocListener`.

9. **Document** in `docs/features/<feature>.md` and update `docs/PROGRESS.md`.

---

## Linting

The project uses `very_good_analysis` — one of the strictest Flutter lint rulesets. Key rules to be aware of:

| Rule | What it enforces |
|------|-----------------|
| `always_put_required_named_parameters_first` | Required params before optional in constructors |
| `prefer_single_quotes` | Single quotes for strings (unless the string contains an apostrophe) |
| `sort_constructors_first` | Constructor declarations before other members |
| `avoid_catches_without_on_clauses` | Use `on ExceptionType catch (e)` not bare `catch (e)` |
| `unawaited_futures` | Futures must be awaited or explicitly ignored |

To check before committing:
```bash
flutter analyze && dart format --set-exit-if-changed .
```

---

## Key Packages Reference

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^9.1.1 | State management |
| `get_it` | ^8.0.3 | Service locator |
| `injectable` | ^2.5.0 | DI annotations |
| `go_router` | ^15.1.2 | Navigation |
| `dio` | ^5.8.0 | HTTP client |
| `drift` | ^2.24.0 | Local SQLite database |
| `flutter_secure_storage` | ^9.2.4 | Token & key storage |
| `encrypt` | ^5.0.3 | AES-256-GCM encryption |
| `msal_auth` | ^3.3.0 | Microsoft SSO (Azure Entra) |
| `workmanager` | ^0.5.2 | Background sync |
| `firebase_crashlytics` | ^4.3.3 | Crash reporting |
| `firebase_messaging` | ^15.2.4 | Push notifications |
| `mobile_scanner` | ^7.0.1 | VIN / barcode scanning |
| `geolocator` | ^13.0.2 | GPS capture |
| `camera` | ^0.11.1 | Photo capture |
| `dartz` | ^0.10.1 | Functional types (Either) |
| `very_good_analysis` | ^7.0.0 | Lint rules |

---

## Troubleshooting

### `build_runner` fails with conflicting outputs
```bash
dart run build_runner build --delete-conflicting-outputs
```

### `flutter pub get` fails with version conflict
Check `pubspec.yaml` — some packages need to be updated together (e.g. `bloc` and `bloc_test` must stay in sync). Run `flutter pub outdated` to see what needs bumping.

### Font-related test failure
The `pubspec.yaml` font block is commented out (font files not yet supplied). If tests reference font assets, ensure the `assets/fonts/` directory exists:
```bash
mkdir -p assets/fonts assets/images assets/icons assets/animations assets/schemas
```

### Injectable generator produces `InvalidType`
This happens when `injectable_generator` can't resolve an abstract dependency. Do not annotate `AppRouter` or `RouterNotifier` with `@injectable` — they are wired manually in `injection.dart` for this reason.

### Missing `firebase_options.dart`
This file is `.gitignore`d. Run `flutterfire configure` (after Firebase project setup) to regenerate it, or ask Platform Ops for the values to copy in manually.
