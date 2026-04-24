# Pickles Direct MVP — Work Completed

> Document created: 24 April 2026  
> SOW reference: v1.4  
> Repository: `tomgooday/picklesdirect` (private)  
> Deployment: Vercel (Web PWA) · CI/CD: GitHub Actions

---

## Overview

This document captures all work completed on the Pickles Direct MVP Flutter application as of 24 April 2026. The app enables equipment vendors to submit assets for auction via Pickles — capturing asset details, photos, and syncing to the Pickles middleware when connected.

The project follows **Clean Architecture** (domain → data → presentation) with **Bloc** state management, **GetIt/Injectable** dependency injection, **Drift/SQLite** local persistence, and a **GitHub Actions** CI/CD pipeline deploying to **Vercel** as a Web PWA.

---

## Commit History

| Commit | Date | Description |
|--------|------|-------------|
| `05aefd3` | 24 Apr 2026 | feat(photo-capture): implement Phase 2 — full photo capture flow |
| `90eafa9` | 24 Apr 2026 | fix(ci): apply dart format to all new asset-capture files |
| `9d9cf54` | 24 Apr 2026 | feat(asset-capture): implement Long Form — category grid, schema-driven form, VIN scanner & GPS |
| `fe7da77` | 24 Apr 2026 | docs: add CHANGELOG covering Sprint 1 — dashboard, CI/CD, and all fixes |
| `bc938e1` | 23 Apr 2026 | fix(web): make Firebase init graceful until credentials are provisioned |
| `675aa06` | 23 Apr 2026 | fix(ci): replace non-existent cyclonedx_dart with anchore/sbom-action |
| `5a36c3a` | 23 Apr 2026 | fix(android): enable core library desugaring for flutter_local_notifications |
| `c4158f6` | 23 Apr 2026 | fix(android): upgrade workmanager 0.5.2 → 0.9.0 for Kotlin 2.1 compat |
| `7818aa9` | 23 Apr 2026 | fix(ci): resolve all three build job failures |
| `e175735` | 23 Apr 2026 | fix(ci): make SonarQube step non-blocking until org is provisioned |
| `fc60426` | 23 Apr 2026 | fix(ci): resolve all three blocking job failures |
| `31d54e0` | 23 Apr 2026 | style: apply dart format to all source files |
| `a8b70c2` | 23 Apr 2026 | fix(ci): remove incorrect working-directory prefixes |
| `4d37afc` | 23 Apr 2026 | Add Vercel deployment: vercel.json config + deploy-web CI job |
| `8972ddf` | 23 Apr 2026 | Initial commit: Pickles Direct MVP — core infrastructure + Auth + Bulk Lead + Dashboard |

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter / Dart 3.9+ |
| Architecture | Clean Architecture (domain / data / presentation) |
| State management | Bloc + flutter_bloc |
| Dependency injection | GetIt + injectable |
| Navigation | GoRouter (declarative, redirect-aware) |
| Local database | Drift / SQLite (5 tables) |
| Encryption at rest | AES-256-GCM via `encrypt` package |
| Secure storage | flutter_secure_storage (Keychain / Keystore) |
| Networking | Dio (auth interceptor + retry interceptor) |
| Camera / Photos | image_picker, flutter_image_compress, mobile_scanner |
| Location | geolocator + geocoding + permission_handler |
| Firebase | Crashlytics (wired), Messaging (dep ready) |
| CI/CD | GitHub Actions |
| Deployment | Vercel (Web PWA) |
| Code quality | `flutter analyze --fatal-infos`, `dart format`, test coverage reporting |

---

## Phase 0 — Project Foundation (23 Apr 2026)

### Core Infrastructure

All foundational plumbing was built in the initial commit. Everything listed here is production-ready and fully wired into the DI container.

| Area | File(s) | Notes |
|------|---------|-------|
| Project scaffold | `pubspec.yaml`, `analysis_options.yaml`, `.gitignore` | All dependencies resolved; strict lint rules enabled |
| App config | `core/config/app_config.dart` | Environment values injected at build time via `--dart-define` |
| Feature flags | `core/config/feature_flags.dart` + `FlagsRepository` | Lightweight in-memory cache with server-refresh; 4 flags defined |
| Constants | `core/constants/app_constants.dart` | Branding, session, photo limits, sync, GPS bounds, T&C version |
| DI container | `core/di/injection.dart`, `injection.config.dart` | GetIt + injectable; router wired manually to avoid circular deps |
| Error types | `core/error/failures.dart`, `exceptions.dart` | Sealed `Failure` hierarchy returned via `Either`; never thrown |
| Networking | `core/network/dio_client.dart`, `network_info.dart` | Auth + retry interceptors; connectivity stream; cert-pinning stub |
| Navigation | `core/router/app_router.dart`, `router_notifier.dart`, `routes.dart` | GoRouter with `redirect` for auth-aware routing |
| Encryption | `core/security/encryption_service.dart` | AES-256-GCM; encryption key generated once and stored in Keychain/Keystore |
| Token storage | `core/security/token_storage.dart` | Access token, refresh token, user ID, onboarding flags — all in secure storage |
| Local database | `core/storage/database/app_database.dart` | Drift/SQLite; 5 tables: `SubmissionDrafts`, `SubmissionPhotos`, `SyncQueue`, `SubmittedAssets`, `AssetSchemas` |
| Sync engine | `core/sync/sync_engine.dart` | Connectivity-aware; exponential backoff (max 5 retries, 10 s base); 2-min SLA |
| Design system | `core/theme/app_theme.dart` | Pickles brand colour tokens, typography scale, spacing dimensions |
| Firebase init | `firebase_options.dart`, `main.dart` | Crashlytics error handler wired; project: `pickles-direct`; graceful fallback until credentials provisioned |
| App entry point | `main.dart` | Firebase, DI, SyncEngine, Crashlytics all initialised before `runApp` |

### CI/CD Pipeline

A full GitHub Actions pipeline was configured and debugged to a passing state.

**Jobs:**
- **Analyse & Format** — `flutter analyze --fatal-infos` + `dart format --set-exit-if-changed`
- **Test** — `flutter test` with coverage reporting
- **Build Android** — produces signed AAB via `flutter build appbundle`
- **Build iOS** — `flutter build ios --no-codesign` (no provisioning required in CI)
- **Build Web** — `flutter build web --release` produces PWA artefact
- **Deploy Web** — Vercel CLI deploys web build to production on every main-branch push
- **SAST** — Anchore SBOM action for dependency scanning (replaces `cyclonedx_dart` which does not exist)
- **SonarQube** — Non-blocking until org is provisioned

**Issues resolved during setup:**
- Incorrect `working-directory` prefixes in matrix steps
- `workmanager` 0.5.2 → 0.9.0 upgrade for Kotlin 2.1 compatibility
- Core library desugaring enabled for `flutter_local_notifications`
- Firebase graceful init (prevents web build crash before `google-services.json` is provisioned)
- `dart format` non-compliance on generated/new files (fixed by running format locally before push)

---

## Phase 1 — Asset Capture / Long Form (24 Apr 2026)

The full single-item asset submission form, including VIN scanning and GPS capture. This was built against a hardcoded schema stub so UX is complete before the middleware API spec arrives.

### Domain Layer

| File | Purpose |
|------|---------|
| `domain/entities/asset_draft.dart` | `AssetDraft` — local submission draft with `fieldValues` map, GPS coords, timestamps |
| `domain/entities/asset_category.dart` | `AssetCategory` — category key, label, icon, and list of field schemas |
| `domain/entities/asset_field_schema.dart` | `AssetFieldSchema` — field key, label, type enum, validation rules, dropdown options |
| `domain/repositories/asset_draft_repository.dart` | Interface: save / load / list / delete drafts |
| `domain/usecases/save_asset_draft.dart` | Enforces 50-draft limit; injects `@injectable` |
| `domain/usecases/load_asset_draft.dart` | Loads draft by ID |

### Data Layer

| File | Purpose |
|------|---------|
| `data/datasources/asset_schema_service.dart` | Hardcoded stub returning `AssetCategory` schemas for 8 categories: earthmoving, transport, agriculture, forklifts, cranes, vehicles, marine, other. Replace with `GET /schemas/{categoryKey}` once middleware spec arrives |
| `data/repositories/asset_draft_repository_impl.dart` | Drift-backed; serialises `fieldValues` to JSON, encrypts with AES-256-GCM, stores in `SubmissionDrafts.assetPayloadEncrypted` |

### Bloc

| File | Purpose |
|------|---------|
| `presentation/bloc/asset_capture_event.dart` | Events: `AssetCaptureStarted`, `AssetFieldChanged`, `AssetGpsRequested`, `AssetVinScanned`, `AssetDraftSaveRequested`, `AssetSubmitRequested` |
| `presentation/bloc/asset_capture_state.dart` | State: category, fieldValues map, validation errors, GPS status, save/submit status enums |
| `presentation/bloc/asset_capture_bloc.dart` | Full logic: schema loading, field validation, GPS via geolocator + geocoding, VIN scanning, draft save to Drift, submit orchestration. Reads user ID directly from `FlutterSecureStorage` (TODO: replace with `AuthRepository.currentUser()` once auth impl is wired) |

### UI

| File | Purpose |
|------|---------|
| `presentation/pages/asset_category_page.dart` | 2-column responsive grid of `CategoryCard`s; taps route to `AssetFormPage` |
| `presentation/pages/asset_form_page.dart` | Schema-driven form; `PopScope` auto-saves on back navigation; validation error summary; "Continue to Photos" CTA |
| `presentation/widgets/category_card.dart` | Grid card showing category icon, label, description |
| `presentation/widgets/schema_field_widget.dart` | Core form engine rendering `text` / `number` / `year` / `dropdown` / `textarea` / `vinScanner` / `gpsCapture` / `currency` field types from schema |
| `presentation/widgets/vin_scanner_sheet.dart` | Modal bottom sheet activating `mobile_scanner`; camera targeting overlay; torch toggle |

### Field Types Supported

`text`, `number`, `year`, `dropdown`, `textarea`, `vinScanner` (barcode/VIN via camera), `gpsCapture` (geolocator + reverse geocoding), `currency`

### Asset Categories (8)

`earthmoving` · `transport` · `agriculture` · `forklifts` · `cranes` · `vehicles` · `marine` · `other`

Each category has a full set of field schemas including serial number, make, model, year, condition, hours/odometer, description, and category-specific fields.

---

## Phase 2 — Photo Capture (24 Apr 2026)

Full photo capture flow integrated with the asset draft, using device camera and gallery, with per-photo category assignment, compression, and a submission confirmation screen.

### Domain Layer

| File | Purpose |
|------|---------|
| `domain/entities/submission_photo.dart` | `SubmissionPhoto` — maps to `SubmissionPhotos` Drift table; stores path, size, dimensions, category, sort order, GPS |
| `domain/entities/photo_category.dart` | `PhotoCategory` entity + `PhotoCategories` abstract class with 11 static constants (5 required, 6 optional) |
| `domain/repositories/photo_repository.dart` | Interface: `addPhoto` / `listPhotos` / `deletePhoto` / `reorderPhotos` / `deleteAllForDraft` / `fileFor` |
| `domain/usecases/add_photo.dart` | Enforces 20-photo cap and 10 MB source file limit before delegating to repository |
| `domain/usecases/list_photos.dart` | Returns photos ordered by `sortOrder` |
| `domain/usecases/delete_photo.dart` | Delegates to repository delete |

### Photo Categories

**Required (must have ≥ 1 photo each):**
`overview_front` (Front View) · `overview_rear` (Rear View) · `overview_left` (Left Side) · `overview_right` (Right Side) · `serial_plate` (Serial / ID Plate)

**Optional:**
`hours_meter` (Hours/Odometer) · `engine_detail` (Engine/Motor) · `interior_cab` (Interior/Cab) · `damage_defect` (Damage/Defects) · `attachment_detail` (Attachment Detail) · `additional` (Additional)

### Data Layer

| File | Purpose |
|------|---------|
| `data/services/photo_compression_service.dart` | `PhotoCompressionService` interface + `PhotoCompressionServiceImpl`; uses `flutter_image_compress` with 80% JPEG quality, min 800×600 output; falls back to file copy if compression fails |
| `data/repositories/photo_repository_impl.dart` | Drift-backed; compresses on add; reads image dimensions via `image` package in a background isolate (`compute`); stores files at `{documents}/photos/{draftId}/{photoId}.jpg`; maintains `photoCount` on parent `SubmissionDraft`; uses `db.` import alias to resolve naming conflict with domain entity |

### Bloc

| File | Purpose |
|------|---------|
| `presentation/bloc/photo_capture_event.dart` | Events: `PhotoCaptureStarted`, `PhotoCaptureImageCaptured`, `PhotoCaptureGalleryPicked`, `PhotoCaptureCategorySelected`, `PhotoCaptureCategoryDismissed`, `PhotoCaptureDeleted`, `PhotoCaptureReordered`, `PhotoCaptureSubmitRequested` |
| `presentation/bloc/photo_capture_state.dart` | State: photos list, pendingFile, status enum, submitStatus enum, computed properties (`hasMinPhotos`, `isAtMaxPhotos`, `missingRequiredKeys`, `coveredRequiredKeys`) |
| `presentation/bloc/photo_capture_bloc.dart` | Full logic: load existing photos on start, capture/gallery flow, category assignment, compress-and-save, delete, optimistic reorder with Drift persistence, min-count validation on submit |

### UI

| File | Purpose |
|------|---------|
| `presentation/pages/photo_capture_page.dart` | Main photo capture screen: progress bar (X/8 required), 3-column thumbnail grid, camera button, gallery button (behind `flagPhotoGalleryImport` feature flag), missing-category hint panel, "Continue" CTA (enabled at ≥ 8 photos) |
| `presentation/pages/submission_confirmation_page.dart` | Post-capture confirmation: success illustration, draft summary card (label, category, photo count, last updated), horizontal photo strip, sync-info banner, "Go to Dashboard" + "Add More Photos" CTAs |
| `presentation/widgets/photo_category_sheet.dart` | Scrollable `DraggableScrollableSheet`; required/optional section headers; covered indicator (checkmark on filled categories); returns selected `PhotoCategory` or null |
| `presentation/widgets/photo_thumbnail_grid.dart` | 3-column `GridView`; per-cell: `Image.file` fill, category label gradient overlay, delete button; empty state with prompt and minimum count |

### Routing

Added `/submit/confirmation/:draftId` to both `Routes` constants and `AppRouter`.

### Constraints Enforced

| Constraint | Value | Where enforced |
|-----------|-------|---------------|
| Minimum photos | 8 | `AddPhoto` use case + `PhotoCaptureBloc._onSubmitRequested` + UI progress bar |
| Maximum photos | 20 | `AddPhoto` use case + UI button disabled state |
| Max source file size | 10 MB | `AddPhoto` use case |
| JPEG quality | 80% | `PhotoCompressionService` |
| Min output dimensions | 800 × 600 px | `PhotoCompressionService` |

---

## Features Built — Complete Checklist

### Authentication (`features/auth`)

- [x] `User` domain entity with `UserStatus` enum
- [x] `AuthRepository` interface (signIn, MSAL, register, reset, signOut, acceptTerms, stream)
- [x] `AuthBloc` — all events and states wired
- [x] `AuthStateStreamBridge` — Bloc state → router redirect enum
- [x] `SplashPage` — resolves auth state on launch
- [x] `LoginPage` — email/password + Microsoft SSO button
- [x] `RegisterPage` — 2-step form with ABN validation
- [x] `ForgotPasswordPage`
- [x] `TermsAcceptancePage` — scroll-to-unlock (BRU-18)
- [x] Shared widgets: `PicklesLogo`, `PasswordField`, `AuthDivider`, `MicrosoftSignInButton`
- [x] Unit tests — 3 test cases
- [ ] `AuthRepositoryImpl` — awaiting middleware spec + Azure Entra config
- [ ] Microsoft MSAL — awaiting Azure Entra tenant ID from Platform Ops

### Post-Login Routing (`features/routing`)

- [x] `ItemQuantityRoutingPage` — "How many items?" → Long Form or Bulk Lead

### Bulk Lead Capture (`features/bulk_lead_capture`)

- [x] `BulkLead` + `BulkLeadAssetItem` domain entities
- [x] `BulkLeadRepository` interface
- [x] `SubmitBulkLead` use case
- [x] `BulkLeadBloc`
- [x] `BulkLeadPage` — vendor contact fields + multi-select asset types
- [x] `BulkLeadConfirmationPage`
- [x] Unit tests — 6 test cases
- [ ] `BulkLeadRepositoryImpl` — awaiting middleware spec

### Asset Capture / Long Form (`features/asset_capture`)

- [x] `AssetDraft`, `AssetCategory`, `AssetFieldSchema` domain entities
- [x] `AssetDraftRepository` interface
- [x] `SaveAssetDraft`, `LoadAssetDraft` use cases
- [x] `AssetDraftRepositoryImpl` — Drift + AES-256-GCM encryption
- [x] `AssetSchemaService` — 8-category hardcoded stub
- [x] `AssetCaptureBloc`
- [x] `AssetCategoryPage` — 2-column responsive category grid
- [x] `AssetFormPage` — schema-driven form with auto-save
- [x] `SchemaFieldWidget` — 8 field type renderers
- [x] `VinScannerSheet` — camera + barcode scanner
- [x] GPS capture with Australia bounds validation
- [x] Draft auto-save on back navigation
- [ ] Server-side schema (`GET /schemas/{categoryKey}`) — awaiting API spec

### Photo Capture (`features/photo_capture`)

- [x] `SubmissionPhoto`, `PhotoCategory` domain entities
- [x] `PhotoRepository` interface
- [x] `AddPhoto`, `ListPhotos`, `DeletePhoto` use cases
- [x] `PhotoRepositoryImpl` — Drift + compression + file storage
- [x] `PhotoCompressionService`
- [x] `PhotoCaptureBloc`
- [x] `PhotoCapturePage` — camera, gallery, categories, progress, grid
- [x] `PhotoCategorySheet` — required/optional category picker
- [x] `PhotoThumbnailGrid` — 3-column grid with delete
- [x] `SubmissionConfirmationPage`
- [x] Min 8 / max 20 enforcement
- [x] Gallery import (behind feature flag)
- [x] Photo reordering with Drift persistence

### Dashboard (`features/dashboard`)

- [x] `SubmissionSummary` domain entity
- [x] `DashboardRepository` interface + `WatchDashboardItems` use case
- [x] `DashboardRepositoryImpl` — `Rx.combineLatest3` over all 3 local tables
- [x] `DashboardBloc`
- [x] `DashboardPage` — AppBar, FAB, pull-to-refresh, section headers
- [x] `SubmissionCard` widget
- [x] `SyncStatusBanner` widget
- [x] `EmptyDashboard` zero-state
- [ ] Live data from server (awaiting middleware spec)
- [ ] Push notification handling (`firebase_messaging` dep ready)

---

## Pending External Inputs (Blockers)

These items cannot be progressed without input from the Pickles team or Platform Ops:

| Item | Needed for | Owner |
|------|-----------|-------|
| Azure Entra tenant ID + client ID | Microsoft MSAL SSO | Platform Ops |
| Middleware OpenAPI / Swagger spec | All `RepositoryImpl` classes + Retrofit clients | Pickles API team |
| Pickles font files | Design system typography (currently system fonts) | Pickles UX team |
| Firebase `google-services.json` (Android) + `GoogleService-Info.plist` (iOS) | Firebase SDK init; run `flutterfire configure` | Platform Ops |
| Firebase Crashlytics SHA-1 / SHA-256 (Android) | Android crash reporting | Platform Ops |
| TLS certificate fingerprints | Certificate pinning in `DioClient` | Pickles infrastructure |
| Asset schema JSON format | Replace hardcoded `AssetSchemaService` stub | Pickles API / UX team |
| SonarQube token + project key | CI quality gate (currently non-blocking) | Platform Ops |

---

## Suggested Next Build Order

Once Phase 1–2 are complete, the following work is recommended in dependency order:

| Priority | Feature | Depends on | Status |
|----------|---------|-----------|--------|
| 1 | **Sync** (`SubmissionSyncService` real impl) | Middleware API spec | ⏳ Blocked |
| 2 | **Auth repository** real impl | Azure Entra + middleware spec | ⏳ Blocked |
| 3 | **Push notifications** | Firebase credentials | ⏳ Blocked |
| 4 | **Profile page** | Auth impl | ⏳ Ready to build (stub exists) |
| 5 | **Submission Status / Valuation** | Sync impl | ⏳ Ready to build (stub exists) |
| 6 | **Onboarding** | All core flows | ⏳ Ready to build (stub exists) |
| 7 | **Server-side schemas** | Middleware spec | ⏳ Blocked |

---

## Code Quality Standards

All code on `main` satisfies:

- `flutter analyze --fatal-infos` — zero issues (infos treated as errors)
- `dart format --set-exit-if-changed` — fully formatted
- Clean Architecture boundaries respected (domain layer has no Flutter or platform imports)
- All Bloc events/states are `sealed`/`final` classes with `Equatable`
- All failures returned as `Either<Failure, T>` — no exceptions thrown across layer boundaries
- All local variables use type inference (`var`, not explicit type annotations)
- No `dynamic` outside of JSON serialisation boundaries

---

*Document generated from PROGRESS.md and git history. For live feature-level status, see `docs/PROGRESS.md` in the repository.*
