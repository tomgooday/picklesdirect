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
| AssetCategoryPage | ⏳ | Stub only — `TODO: implement` |
| AssetFormPage | ⏳ | Stub accepts `categoryKey` + optional `draftId` |
| Schema-driven form engine | ⏳ | Needs middleware schema JSON spec |
| VIN / barcode scanner | ⏳ | `mobile_scanner` dep ready |
| GPS capture | ⏳ | `geolocator` dep ready |
| Draft auto-save | ⏳ | Drift tables ready |

---

## Feature: Photo Capture (`features/photo_capture`)

| Component | Status | Notes |
|-----------|--------|-------|
| PhotoCapturePage | ⏳ | Stub accepts `draftId` |
| Camera integration | ⏳ | `camera`, `image_picker` deps ready |
| Photo compression | ⏳ | `flutter_image_compress` dep ready; target 500 KB |
| Photo category assignment | ⏳ | Schema-driven photo categories (overview, serial plate, etc.) |
| Min/max enforcement | ⏳ | Min 8, max 20 photos (BR constants defined) |

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
2.  Asset Capture Long Form         Needs schema spec; camera/GPS ready
3.  Photo Capture                   Depends on Asset Capture draftId
4.  Sync (SubmissionSyncService)    Needs middleware spec; engine already built
5.  Auth repository (real impl)     Needs Azure Entra + middleware spec
6.  Push notifications              firebase_messaging ready
7.  Profile                         After auth impl
8.  Submission Status / Valuation   After sync impl
9.  Onboarding                      After all core flows done
```
