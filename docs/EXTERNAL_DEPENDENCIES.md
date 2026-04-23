# External Dependencies & Integration Checklist

> Items below require input from the Pickles team or Platform Ops before they can be implemented.
> Reference this document to unblock features as information becomes available.

---

## 1. Firebase

**Project:** `pickles-direct`  
**Console:** https://console.firebase.google.com/u/0/project/pickles-direct/overview

### What's done

- Firebase Core initialised in `main.dart`.
- Firebase Crashlytics wired (`FlutterError.onError` + `runZonedGuarded`).
- `firebase_options.dart` has placeholder values — **must be replaced** before release.

### Actions required

| Action | Who | Command / Location |
|--------|-----|--------------------|
| Run `flutterfire configure` after Platform Ops provisions the project | Developer | `dart pub global activate flutterfire_cli && flutterfire configure` |
| Obtain SHA-1 and SHA-256 key fingerprints (Android) | Platform Ops → Developer | `keytool -list -v -keystore ~/.android/debug.keystore` |
| Add `google-services.json` to `android/app/` | Developer (from Firebase Console) | Firebase Console → Project settings → Android app |
| Add `GoogleService-Info.plist` to `ios/Runner/` | Developer (from Firebase Console) | Firebase Console → Project settings → iOS app |
| Enable Firebase Messaging for push notifications | Platform Ops | Firebase Console → Cloud Messaging |

### How `firebase_options.dart` is managed

The file is listed in `.gitignore` (secrets). After running `flutterfire configure`, the generated file is placed at `lib/firebase_options.dart` and must **not** be committed to the repository. Use CI secrets to inject it at build time.

---

## 2. Azure Entra External ID (MSAL)

**Package:** `msal_auth ^3.3.0`

### What's done

- `AppConfig` has `azureClientId` and `azureTenantId` fields (populated via `--dart-define`).
- `MicrosoftSignInButton` is automatically **disabled** when `azureClientId` is empty.
- `AuthRepository` interface has `signInWithMsal()` defined.
- `AuthBloc` has `AuthMsalSignInRequested` event handler wired.

### Actions required from Platform Ops

| Item | Where it goes |
|------|--------------|
| Azure Entra **Tenant ID** | `--dart-define=AZURE_TENANT_ID=<value>` at build time |
| Azure Entra **Client ID** (the app registration) | `--dart-define=AZURE_CLIENT_ID=<value>` at build time |
| Redirect URI scheme (iOS) | `ios/Runner/Info.plist` — `CFBundleURLSchemes` |
| MSAL config JSON (Android) | `android/app/src/main/res/raw/msal_config.json` |

### Implementation steps (once config is available)

1. Add `AZURE_TENANT_ID` and `AZURE_CLIENT_ID` to CI secrets.
2. Create `android/app/src/main/res/raw/msal_config.json`:
   ```json
   {
     "client_id": "<CLIENT_ID>",
     "authorization_user_agent": "DEFAULT",
     "redirect_uri": "msauth://<PACKAGE_NAME>/<BASE64_URL_ENCODED_PACKAGE_SIGNATURE>",
     "authorities": [
       {
         "type": "AAD",
         "audience": { "type": "AzureADMyOrg", "tenant_id": "<TENANT_ID>" }
       }
     ]
   }
   ```
3. Add URL scheme to `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleURLSchemes</key>
   <array><string>msauth.<BUNDLE_ID></string></array>
   ```
4. Implement `AuthRepositoryImpl.signInWithMsal()` using `MsalAuth.acquireToken()`.
5. `MicrosoftSignInButton` will automatically enable once `azureClientId` is non-empty.

---

## 3. Middleware API

**Packages ready:** `dio` (configured), `retrofit`/`retrofit_generator` (to be added when spec arrives)

### What's done

- `DioClient` is configured with base URL, `AuthInterceptor`, and `RetryInterceptor`.
- All repository interfaces defined with `Either<Failure, T>` return types.
- Failure hierarchy ready (`NetworkFailure`, `ServerFailure`, `AuthFailure`, `CacheFailure`).

### Actions required from Pickles API team

| Item | Needed for |
|------|-----------|
| OpenAPI / Swagger specification (all endpoints) | All `*RepositoryImpl` classes |
| Auth endpoint: `POST /auth/token` | `AuthRepositoryImpl.signInWithEmailPassword` |
| Auth endpoint: `POST /auth/register` | `AuthRepositoryImpl.register` |
| Auth endpoint: `POST /auth/refresh` | `AuthInterceptor` token refresh |
| Auth endpoint: `POST /auth/forgot-password` | `AuthRepositoryImpl.sendPasswordReset` |
| Submission endpoint: `POST /submissions` | `SubmissionSyncServiceImpl` |
| Bulk lead endpoint: `POST /leads/bulk` | `BulkLeadRepositoryImpl` |
| Submission status endpoint: `GET /submissions/{id}` | Dashboard + SubmissionDetailPage |
| Asset schema endpoint: `GET /schemas/{categoryKey}` | Schema-driven Long Form |
| User profile endpoint: `GET /users/me` | ProfilePage |

### Adding API clients (step by step)

1. Add to `pubspec.yaml`:
   ```yaml
   dependencies:
     retrofit: ^4.x.x
   dev_dependencies:
     retrofit_generator: ^8.x.x
   ```
2. Create the client interface at `lib/features/<feature>/data/datasources/<feature>_api.dart`:
   ```dart
   @RestApi()
   abstract class SubmissionApi {
     factory SubmissionApi(Dio dio, {String baseUrl}) = _SubmissionApi;
     @POST('/submissions')
     Future<SubmissionResponse> submitAsset(@Body() SubmissionRequest request);
   }
   ```
3. Run `dart run build_runner build`.
4. Register in `injection.dart` or annotate with `@injectable`.

### Base URL configuration

Set via `--dart-define=MIDDLEWARE_BASE_URL=https://api.picklesdirect.com.au` at build time.
Default in `AppConfig`: `'https://api.picklesdirect.com.au'`.

---

## 4. Design System Fonts

**Font families referenced:** `PicklesDisplay`, `PicklesBody`

### What's done

- `AppTheme` sets `fontFamily: 'PicklesBody'` — falls back to system default until files arrive.
- `pubspec.yaml` has the font block commented out with instructions.

### Actions required from Pickles UX team

| File | Weight | Goes in |
|------|--------|---------|
| `PicklesDisplay-Regular.ttf` | 400 | `assets/fonts/` |
| `PicklesDisplay-Bold.ttf` | 700 | `assets/fonts/` |
| `PicklesBody-Regular.ttf` | 400 | `assets/fonts/` |
| `PicklesBody-Medium.ttf` | 500 | `assets/fonts/` |
| `PicklesBody-SemiBold.ttf` | 600 | `assets/fonts/` |

### Once files are provided

Uncomment the `fonts:` block in `pubspec.yaml`:
```yaml
fonts:
  - family: PicklesDisplay
    fonts:
      - asset: assets/fonts/PicklesDisplay-Regular.ttf
      - asset: assets/fonts/PicklesDisplay-Bold.ttf
        weight: 700
  - family: PicklesBody
    fonts:
      - asset: assets/fonts/PicklesBody-Regular.ttf
      - asset: assets/fonts/PicklesBody-Medium.ttf
        weight: 500
      - asset: assets/fonts/PicklesBody-SemiBold.ttf
        weight: 600
```

The theme will automatically pick them up — no other changes needed.

---

## 5. Pickles Design System Tokens

**Source:** https://pickles.sharepoint.com/sites/ExperienceDesign/SitePages/Developers-Guide.aspx  
**Figma:** https://www.figma.com/design/0sAXPf39C6pUj6KuAp9ZP1/Pickles.my--New?node-id=10414-42909

Both require Pickles SSO — cannot be accessed externally.

### What's done

- `app_theme.dart` uses inferred brand tokens (Pickles red `#E8321A`, clean white surfaces, Material 3).
- All token values are in one file — updating them cascades through the entire app.

### When design tokens are available

1. Update colour hex values in `AppColours.light` and `AppColours.dark`.
2. Update font sizes / weights in `AppTextStyles`.
3. Update spacing / radius values in `AppDimensions`.
4. Replace the text-based `PicklesLogo` widget with the SVG asset in `assets/images/`.

---

## 6. TLS Certificate Pinning

**Status:** Placeholder comment in `DioClient`.

### When to implement

Before production release. Obtain the TLS certificate fingerprint(s) from Pickles infrastructure team.

```dart
// In DioClient, replace the placeholder with:
(httpClient.findProxy, httpClient.badCertificateCallback) = (
  null,
  (cert, host, port) => cert.pem == _expectedCertPem,
);
```

---

## 7. SonarQube

**Config:** `sonar-project.properties`

| Property | Value needed |
|----------|-------------|
| `sonar.projectKey` | Assigned by Platform Ops |
| `sonar.token` | CI secret: `SONAR_TOKEN` |
| `sonar.host.url` | Pickles SonarQube instance URL |

Add `SONAR_TOKEN` and `SONAR_HOST_URL` to GitHub Actions repository secrets once provisioned.
