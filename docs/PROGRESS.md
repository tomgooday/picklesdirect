# Pickles Direct — Build Progress Tracker

> Last updated: April 2026  
> SOW reference: v1.4  
> All tests passing · Zero analysis errors

Legend: ✅ Complete · 🔧 In progress · ⏳ Not started · 🔒 Blocked (needs external input)

---

## Core Infrastructure

| Area | Status | Files | Notes |
|------|--------|-------|-------|
| Project scaffold | ✅ | `pubspec.yaml`, `analysis_options.yaml`, `.gitignore` | All deps resolved |
| CI/CD pipeline | ✅ | `.github/workflows/ci.yml` | Quality gates, test coverage, SAST, builds |
| App config (env) | ✅ | `core/config/app_config.dart` | Values via `--dart-define` at build time |
| Feature flags | ✅ | `core/config/feature_flags.dart` | Lightweight custom impl (no external dep) |
| Constants | ✅ | `core/constants/app_constants.dart` | Branding, session, photo limits, sync, GPS bounds, T&C version |
| Dependency injection | ✅ | `core/di/injection.dart`, `injection.config.dart` | GetIt + injectable; Router wired manually |
| Error types | ✅ | `core/error/exceptions.dart`, `failures.dart` | Sealed Failure hierarchy + data exceptions |
| Networking (DIO) | ✅ | `core/network/dio_client.dart` | Auth + retry interceptors; cert pinning stub |
| Network info | ✅ | `core/network/network_info.dart` | Connectivity stream + isConnected |
| Navigation | ✅ | `core/router/app_router.dart`, `router_notifier.dart`, `routes.dart` | GoRouter + redirect logic |
| Encryption | ✅ | `core/security/encryption_service.dart` | AES-256-GCM; key in Keychain/Keystore |
| Token storage | ✅ | `core/security/token_storage.dart` | flutter_secure_storage |
| Local database | ✅ | `core/storage/database/app_database.dart` | Drift/SQLite — 5 tables |
| Sync engine | ✅ | `core/sync/sync_engine.dart` | Connectivity-aware; exponential backoff |
| Design system | ✅ | `core/theme/app_theme.dart` | Colours, typography, dimensions — Pickles brand tokens |
| Firebase init | ✅ | `firebase_options.dart`, `main.dart` | Crashlytics wired; project: `pickles-direct` |
| App entry point | ✅ | `main.dart` | Firebase, DI, SyncEngine, Crashlytics error handlers |

---

## Feature: Authentication (`features/auth`)

> See [docs/features/auth.md](features/auth.md) for full detail.

| Component | Status | Notes |
|-----------|--------|-------|
| Domain entity (`User`) | ✅ | `UserStatus` enum; `hasAcceptedCurrentTc` getter |
| Repository interface | ✅ | signIn, signInWithMsal, register, sendPasswordReset, signOut, acceptTerms, authStateChanges |
| Auth Bloc | ✅ | All events/states wired |
| Auth state bridge | ✅ | `AuthStateStreamBridge` — maps Bloc states → router enum |
| **SplashPage** | ✅ | Resolves auth state on launch |
| **LoginPage** | ✅ | Email/password + Microsoft SSO button |
| **RegisterPage** | ✅ | 2-step: credentials + business profile (ABN validation) |
| **ForgotPasswordPage** | ✅ | Send reset link + success state |
| **TermsAcceptancePage** | ✅ | Scrollable T&C with scroll-to-unlock (BRU-18) |
| Shared widgets | ✅ | PicklesLogo, PasswordField, AuthDivider, MicrosoftSignInButton |
| Auth repository implementation | ⏳ | Needs middleware API spec + Azure Entra config |
| Microsoft MSAL integration | 🔒 | Waiting on Azure Entra tenant ID + client ID from Platform Ops |
| Unit tests (Bloc) | ✅ | 3 test cases — check, sign-in (new session), unauthenticated |

---

## Feature: Post-Login Routing (`features/routing`)

| Component | Status | Notes |
|-----------|--------|-------|
| **ItemQuantityRoutingPage** | ✅ | "How many items?" — routes to Long Form or Bulk Lead |
| Route (`/routing`) | ✅ | Triggered by `AuthState.needsRouting` in RouterNotifier |

---

## Feature: Bulk Lead Capture (`features/bulk_lead_capture`)

> See [docs/features/bulk-lead-capture.md](features/bulk-lead-capture.md) for full detail.

| Component | Status | Notes |
|-----------|--------|-------|
| Domain entity (`BulkLead`, `BulkLeadAssetItem`) | ✅ | `isReadyToSubmit` validation |
| Repository interface | ✅ | `submitBulkLead` |
| Submit use case | ✅ | Pre-submission validation |
| BulkLead Bloc | ✅ | Vendor details, asset type toggle, submission |
| **BulkLeadPage** | ✅ | Vendor contact fields + multi-select asset types |
| **BulkLeadConfirmationPage** | ✅ | Success confirmation with next-steps messaging |
| Shared widgets | ✅ | VendorContactFields, AssetTypeSelector |
| Repository implementation | ⏳ | Needs middleware API spec |
| Unit tests (Bloc) | ✅ | 6 test cases |

---

## Feature: Asset Capture / Long Form (`features/asset_capture`)

| Component | Status | Notes |
|-----------|--------|-------|
| Domain entities (`AssetDraft`, `AssetCategory`, `AssetFieldSchema`) | ✅ | Full Equatable entities |
| Repository interface (`AssetDraftRepository`) | ✅ | save / load / list / delete |
| Use cases (`SaveAssetDraft`, `LoadAssetDraft`) | ✅ | @injectable; draft limit enforced |
| Repository implementation (`AssetDraftRepositoryImpl`) | ✅ | Drift + AES-256-GCM encryption wired |
| `AssetSchemaService` (hardcoded stub) | ✅ | 8 categories: earthmoving, transport, agriculture, forklifts, cranes, vehicles, marine, other |
| `AssetCaptureBloc` | ✅ | Started / FieldChanged / GpsRequested / VinScanned / SaveDraft / Submit |
| **AssetCategoryPage** | ✅ | 2-column responsive grid; tap → AssetFormPage |
| **AssetFormPage** | ✅ | Schema-driven; auto-save on pop; validation summary; Continue to Photos CTA |
| `SchemaFieldWidget` (form engine) | ✅ | text / number / year / dropdown / textarea / vinScanner / gpsCapture / currency |
| `VinScannerSheet` | ✅ | Camera + targeting overlay + torch toggle via `mobile_scanner` |
| VIN / barcode scanner | ✅ | `mobile_scanner` wired via `VinScannerSheet` bottom sheet |
| GPS capture | ✅ | `geolocator` + `geocoding` + permission handler; Australia bounds check |
| Draft auto-save | ✅ | Saves to Drift on "Save Draft" tap and on back navigation (`PopScope`) |
| Schema-driven form (server) | ⏳ | Replace `AssetSchemaService` with `GET /schemas/{categoryKey}` once spec arrives |

---

## Feature: Photo Capture (`features/photo_capture`)

| Component | Status | Notes |
|-----------|--------|-------|
| Domain entity (`SubmissionPhoto`, `PhotoCategory`) | ✅ | Full Equatable entities; 11 categories (5 required) |
| Repository interface (`PhotoRepository`) | ✅ | addPhoto / listPhotos / deletePhoto / reorderPhotos / deleteAllForDraft |
| Use cases (`AddPhoto`, `ListPhotos`, `DeletePhoto`) | ✅ | @injectable; max-count enforced in `AddPhoto` |
| Repository implementation (`PhotoRepositoryImpl`) | ✅ | Drift + `flutter_image_compress` + `image` for dimensions; file to `{docs}/photos/{draftId}/` |
| `PhotoCompressionService` | ✅ | `flutter_image_compress`; target 80% JPEG quality, min 800×600 |
| `PhotoCaptureBloc` | ✅ | Started / ImageCaptured / GalleryPicked / CategorySelected / Deleted / Reordered / SubmitRequested |
| **PhotoCapturePage** | ✅ | Progress bar, 3-col grid, camera + gallery (feature-flagged), category bottom sheet, Continue CTA |
| `PhotoCategorySheet` | ✅ | Scrollable sheet; required/optional sections; covered indicator |
| `PhotoThumbnailGrid` | ✅ | 3-column grid; delete button; category label overlay |
| **SubmissionConfirmationPage** | ✅ | Success illustration, draft summary card, photo strip, sync info, Dashboard CTA |
| Photo reordering | ✅ | Drag-reorder persists sort order to Drift |
| Min/max enforcement | ✅ | Min 8, max 20; progress bar + missing-category hint |
| Gallery import | ✅ | Behind `flagPhotoGalleryImport` feature flag |
| Route (`/submit/confirmation/:draftId`) | ✅ | Added to `Routes` + `AppRouter` |

---

## Feature: Dashboard (`features/dashboard`)

> See [docs/features/dashboard.md](features/dashboard.md) for full detail.

| Component | Status | Notes |
|-----------|--------|-------|
| Domain entity (`SubmissionSummary`) | ✅ | `SubmissionStatus` enum; `isLocal`, `hasValuation` getters |
| Repository interface | ✅ | `watchAllItems` stream |
| Watch use case | ✅ | `WatchDashboardItems` |
| Repository implementation | ✅ | `Rx.combineLatest3` over `SubmissionDrafts` + `SyncQueue` + `SubmittedAssets` |
| Dashboard Bloc | ✅ | Started / SyncRequested / internal stream events |
| **DashboardPage** | ✅ | AppBar, FAB, pull-to-refresh, section headers |
| `SubmissionCard` widget | ✅ | Category icon, status chip, photo count, relative date, sync error |
| `SyncStatusBanner` widget | ✅ | Animated; syncing + failed states; tap to retry |
| `EmptyDashboard` widget | ✅ | Zero-state illustration + CTA |
| `AppDatabase` DI registration | ✅ | Added as `lazySingleton` in `injection.dart` |
| Live data from server | ⏳ | Needs middleware spec → `SubmissionSyncService` impl |
| Push notification handling | ⏳ | `firebase_messaging` dep ready |

---

## Feature: Submission Status (`features/submission_status`)

| Component | Status | Notes |
|-----------|--------|-------|
| SubmissionDetailPage | ⏳ | Stub accepts `submissionId` |
| Status timeline | ⏳ | |
| Valuation response | ⏳ | |

---

## Feature: Onboarding (`features/onboarding`)

| Component | Status | Notes |
|-----------|--------|-------|
| OnboardingPage | ⏳ | Stub only |

---

## Feature: Profile (`features/profile`)

| Component | Status | Notes |
|-----------|--------|-------|
| ProfilePage | ⏳ | Stub only |
| Edit business details | ⏳ | |
| Sign out | ⏳ | Wire to `AuthBloc.AuthSignOutRequested` |

---

## Feature: Help (`features/help`)

| Component | Status | Notes |
|-----------|--------|-------|
| HelpPage | ⏳ | Stub only |

---

## Pending External Inputs

These items are blocked on information from the Pickles team or Platform Ops:

| Item | Needed for | Owner |
|------|-----------|-------|
| Azure Entra tenant ID + client ID | MSAL sign-in (Microsoft SSO) | Platform Ops |
| Middleware OpenAPI / Swagger spec | All repository implementations + retrofit clients | Pickles API team |
| Pickles font files (`PicklesDisplay-Regular`, `PicklesBody-Regular`, etc.) | Design system typography | Pickles UX team |
| Firebase Crashlytics SHA-1 / SHA-256 (Android) | Android crash reporting | Platform Ops |
| `google-services.json` (Android) + `GoogleService-Info.plist` (iOS) | Firebase SDK init | Platform Ops / run `flutterfire configure` |
| TLS certificate fingerprints | Certificate pinning in DioClient | Pickles infrastructure |
| Asset schema JSON format | Schema-driven Long Form | Pickles API / UX team |
| SonarQube token + project key | CI quality gate | Platform Ops |

---

## Suggested Next Build Order

```
1.  Dashboard (stub → real)         ✅ DONE — local data wired; live data pending middleware
2.  Asset Capture Long Form         ✅ DONE — 8 categories, full form engine, VIN scanner, GPS, draft auto-save
3.  Photo Capture                   ✅ DONE — camera + gallery, 11 categories, compression, grid, confirmation
4.  Sync (SubmissionSyncService)    Needs middleware spec; engine already built
5.  Auth repository (real impl)     Needs Azure Entra + middleware spec
6.  Push notifications              firebase_messaging ready
7.  Profile                         After auth impl
8.  Submission Status / Valuation   After sync impl
9.  Onboarding                      After all core flows done
```
