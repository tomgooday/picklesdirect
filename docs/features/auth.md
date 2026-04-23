# Feature: Authentication (`features/auth`)

> **SOW refs:** BR-01 – BR-13, BRU-01 – BRU-20  
> **Status:** UI and Bloc complete. Repository implementation pending Azure Entra + middleware spec.

---

## Contents

1. [User Flow](#user-flow)
2. [File Map](#file-map)
3. [Domain Layer](#domain-layer)
4. [Bloc Layer](#bloc-layer)
5. [Pages](#pages)
6. [Shared Widgets](#shared-widgets)
7. [Routing Integration](#routing-integration)
8. [Pending Work](#pending-work)
9. [Test Coverage](#test-coverage)

---

## User Flow

```
App launch
    ↓
SplashPage → dispatches AuthCheckRequested
    ├── Authenticated (session restored) ───────────────→ Dashboard
    ├── TermsRequired (session exists but T&C outdated) → TermsAcceptancePage
    └── Unauthenticated ──────────────────────────────→ LoginPage
              ↓                          ↑
         RegisterPage ──────────────────┘
              ↓
         Step 1 (credentials) → Step 2 (business profile + consent)
              ↓
         TermsAcceptancePage (first use)
              ↓
         ItemQuantityRoutingPage (Step 1a — new session, SOW v1.4)

LoginPage → ForgotPasswordPage (password reset email sent → back to login)
```

---

## File Map

```
lib/features/auth/
├── data/
│   └── auth_state_stream_bridge.dart   # Maps AuthBloc states → RouterNotifier enum
│
├── domain/
│   ├── entities/
│   │   └── user.dart                   # User entity + UserStatus enum
│   └── repositories/
│       └── auth_repository.dart        # Abstract interface
│
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart              # Bloc + event/state parts
    │   ├── auth_event.dart             # (part file)
    │   └── auth_state.dart             # (part file)
    ├── pages/
    │   ├── splash_page.dart
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   ├── forgot_password_page.dart
    │   └── terms_acceptance_page.dart
    └── widgets/
        ├── pickles_logo.dart
        ├── password_field.dart
        ├── auth_divider.dart
        └── microsoft_sign_in_button.dart
```

---

## Domain Layer

### `User` entity (`domain/entities/user.dart`)

| Field | Type | Notes |
|-------|------|-------|
| `id` | `String` | Server-assigned vendor ID |
| `email` | `String` | |
| `displayName` | `String` | Full name |
| `status` | `UserStatus` | active / pendingApproval / suspended / closed |
| `businessName` | `String?` | Set during registration step 2 |
| `abn` | `String?` | 11-digit Australian Business Number |
| `phone` | `String?` | Mobile number |
| `tcVersionAccepted` | `String?` | T&C version string (e.g. `"1.0"`) |
| `privacyVersionAccepted` | `String?` | Privacy policy version |

**Computed properties:**

```dart
bool get isActive              // status == UserStatus.active
bool get hasAcceptedCurrentTc  // tcVersionAccepted != null
bool get hasAcceptedPrivacy    // privacyVersionAccepted != null
```

**Note:** `hasAcceptedCurrentTc` currently checks for non-null only. When implementing the real auth repository, compare against `AppConstants.termsVersion` to enforce version-specific acceptance.

### `AuthRepository` interface (`domain/repositories/auth_repository.dart`)

```dart
abstract interface class AuthRepository {
  Future<User?> getCurrentUser();
  Future<Either<Failure, User>> signInWithEmailPassword({required String email, required String password});
  Future<Either<Failure, User>> signInWithMsal();
  Future<Either<Failure, User>> register({required String email, required String password, required String displayName});
  Future<Either<Failure, Unit>> sendPasswordReset({required String email});
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Unit>> acceptTerms({required String version});
  Future<Either<Failure, Unit>> acceptPrivacyPolicy({required String version});
  Stream<User?> get authStateChanges;
}
```

**Implementation:** `AuthRepositoryImpl` (not yet created) will live at `features/auth/data/repositories/auth_repository_impl.dart`.

---

## Bloc Layer

### Events (`auth_event.dart`)

| Event | Payload | Trigger |
|-------|---------|---------|
| `AuthCheckRequested` | — | SplashPage on mount, session restore |
| `AuthSignInRequested` | `email`, `password` | Login form submit |
| `AuthMsalSignInRequested` | — | "Sign in with Microsoft" button |
| `AuthRegisterRequested` | `email`, `password`, `displayName` | Register step 2 submit |
| `AuthForgotPasswordRequested` | `email` | Forgot password form submit |
| `AuthTermsAccepted` | `version` | Terms acceptance page accept button |
| `AuthSignOutRequested` | — | Profile sign out / session expiry |

### States (`auth_state.dart`)

| State | When emitted | Router reaction |
|-------|-------------|-----------------|
| `AuthInitial` | Initial state | — |
| `AuthLoading` | Any async operation in flight | — |
| `AuthAuthenticated` | Session restored via `AuthCheckRequested` | → Dashboard |
| `AuthNewSession` | Fresh interactive sign-in (email/MSAL) | → `/routing` (Step 1a) |
| `AuthUnauthenticated` | No session / sign-out | → Login |
| `AuthTermsRequired` | Authenticated but T&C not accepted | → `/terms` |
| `AuthPasswordResetSent` | Reset email dispatched successfully | Show success UI |
| `AccountSuspendedFailure` | Suspended account tries to sign in (BR-22) | Show error |
| `AuthFailureState` | Any repository error | Show SnackBar |

### Key behaviour

- `AuthNewSession` vs `AuthAuthenticated`: fresh interactive sign-ins emit `AuthNewSession` so the router routes the user through the Step 1a routing screen first. Session restores (`AuthCheckRequested`) emit `AuthAuthenticated` and skip it.
- The Bloc subscribes to `AuthRepository.authStateChanges` to handle remote sign-out and token expiry events automatically.

### `AuthStateStreamBridge` (`data/auth_state_stream_bridge.dart`)

Implements `AuthStateStream` (the router's interface) by mapping the Bloc's sealed states to the router's `AuthState` enum:

```
AuthInitial / AuthLoading      → unknown
AuthAuthenticated              → authenticated
AuthNewSession                 → needsRouting
AuthUnauthenticated            → unauthenticated
AccountSuspendedFailure        → unauthenticated
AuthTermsRequired              → onboarding
AuthFailureState / AuthPasswordResetSent → unknown (no navigation change)
```

Registered as `@Singleton(as: AuthStateStream)` so `RouterNotifier` receives it via DI.

---

## Pages

### `SplashPage`

- Provides a fresh `AuthBloc` and dispatches `AuthCheckRequested` immediately.
- Shows the Pickles logo + loading indicator while resolving.
- Listens for the first non-loading state and navigates via `context.go()`.
- **Do not** add logic here — keep it purely a state-resolver.

### `LoginPage`

- Email and password fields with inline validation.
- "Forgot password?" link → `Routes.forgotPassword`.
- Primary CTA: "Sign In" (shows spinner while loading).
- `AuthDivider` + `MicrosoftSignInButton` — SSO button is **disabled** until `AppConfig.azureClientId` is non-empty.
- "Don't have an account? Register" → `Routes.register`.
- Error SnackBar on `AuthFailureState`.

### `RegisterPage`

Two-step form with animated `SlideTransition` between steps.

**Step 1 — Credentials:**
- Full name, email, password (min 8 chars), confirm password.
- "Already have an account? Sign in" link → `context.pop()`.

**Step 2 — Business profile:**
- Business name, ABN (11-digit with ATO checksum algorithm validation), mobile number.
- Two consent checkboxes:
  - Terms & Conditions link → `Routes.termsAcceptance`
  - Privacy Policy link → TODO (open `AppConstants.privacyPolicyUrl`)
- Both checkboxes must be checked before "Create Account" is enabled.
- On `AuthTermsRequired` state → redirects to `Routes.termsAcceptance`.

**ABN Validation:** Full ATO checksum algorithm implemented inline in `_validateAbn()`.

### `ForgotPasswordPage`

- Single email field; "Send Reset Link" CTA.
- On success (`AuthPasswordResetSent`): shows `_SuccessView` with "Check your inbox" message.
- "Back to Sign In" button → `context.pop()`.

### `TermsAcceptancePage`

- Scroll-to-unlock: checkbox is disabled until the user scrolls to the bottom of the T&C text (BRU-18).
- T&C text is inline (10 sections); version shown in header and footer.
- "Accept & Continue" CTA: dispatches `AuthTermsAccepted(version: AppConstants.termsVersion)`.
- On `AuthAuthenticated` → `context.go('/')` to trigger router redirect.
- **To update T&C content:** edit the `_buildTermsSections()` method and bump `AppConstants.termsVersion`. Users will be prompted to re-accept on next login.

---

## Shared Widgets

### `PicklesLogo`

```dart
PicklesLogo(size: LogoSize.small | medium | large)
```

Text-based wordmark ("Pickles **Direct**") + "Upload. Offload." tagline. To replace with an SVG asset once supplied by UX team: swap for `SvgPicture.asset('assets/images/pickles_direct_logo.svg')`.

### `PasswordField`

```dart
PasswordField(
  controller: _passwordController,
  label: 'Password',      // optional, defaults to 'Password'
  hint: 'Min. 8 chars',   // optional
  validator: _validateFn, // optional
  textInputAction: TextInputAction.next, // optional
  onFieldSubmitted: (_) => ..., // optional
)
```

Show/hide toggle button. `obscureText` managed internally.

### `AuthDivider`

```dart
AuthDivider(label: 'or continue with') // label optional
```

Horizontal divider with centred label text.

### `MicrosoftSignInButton`

```dart
MicrosoftSignInButton(
  onPressed: () => ..., // pass null to disable
  isLoading: false,
)
```

Microsoft brand-compliant 4-colour logo squares. Disable by passing `onPressed: null` (done automatically in `LoginPage` when `AppConfig.azureClientId` is empty).

---

## Routing Integration

The auth feature integrates with the router via two mechanisms:

1. **`AuthStateStreamBridge`** — feeds the auth state stream that `RouterNotifier` consumes. When auth state changes, GoRouter's `refreshListenable` triggers a redirect evaluation.

2. **`BlocListener` in pages** — handles navigation for states that don't change the router's auth enum (e.g., `AuthPasswordResetSent` shows a success view within the same page; `AuthTermsRequired` navigates to the terms page explicitly).

### Route guards summary

```
/ (splash)          → always public
/login              → public
/register           → public
/forgot-password    → public
/terms              → public
/routing            → only shown when RouterNotifier.authState == needsRouting
/dashboard + shell  → requires RouterNotifier.authState == authenticated
```

---

## Pending Work

| Item | Blocked on |
|------|-----------|
| `AuthRepositoryImpl` (real implementation) | Middleware API spec + Azure Entra config |
| MSAL interactive sign-in (`signInWithMsal`) | Azure Entra tenant ID + client ID |
| Token refresh logic in `AuthInterceptor` | `AuthRepositoryImpl` |
| Email verification flow | Middleware spec |
| Biometric re-authentication | After auth impl |

### Azure Entra setup (when config is available)

1. Add to `AppConfig`: `azureClientId`, `azureTenantId`.
2. In `AuthRepositoryImpl.signInWithMsal()`: call `MsalAuth.acquireToken(...)` using the `msal_auth` package.
3. Configure `android/app/src/main/res/raw/msal_config.json` and iOS info.plist URL scheme.
4. The `MicrosoftSignInButton` will automatically become enabled when `azureClientId` is non-empty.

---

## Test Coverage

**File:** `test/features/auth/auth_bloc_test.dart`

| Test | Description |
|------|------------|
| `AuthCheckRequested — no user cached` | Emits `[AuthLoading, AuthUnauthenticated]` |
| `AuthCheckRequested — active user cached` | Emits `[AuthLoading, AuthAuthenticated]` |
| `AuthSignInRequested — success` | Emits `[AuthLoading, AuthNewSession]` (new session → routing screen) |

**To add:** failure cases (invalid credentials, network error, suspended account), `AuthForgotPasswordRequested`, `AuthTermsAccepted`.
