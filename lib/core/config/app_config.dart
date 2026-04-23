/// Environment-aware configuration. Values are injected at build time via
/// `--dart-define` flags so no secrets are baked into source.
library;

enum AppEnvironment { development, staging, production }

class AppConfig {
  const AppConfig._({
    required this.environment,
    required this.middlewareBaseUrl,
    required this.kongApiKey,
    required this.azureClientId,
    required this.azureTenantId,
    required this.azureB2cPolicySignIn,
    required this.azureB2cPolicyReset,
    required this.azureRedirectUri,
    required this.firebaseProjectId,
    required this.sentinelPinCertHash,
    required this.featureFlagsUrl,
  });

  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    final resolvedEnv = switch (env) {
      'production' => AppEnvironment.production,
      'staging' => AppEnvironment.staging,
      _ => AppEnvironment.development,
    };

    return AppConfig._(
      environment: resolvedEnv,
      middlewareBaseUrl: const String.fromEnvironment(
        'MIDDLEWARE_BASE_URL',
        defaultValue: 'https://api-dev.pickles.com.au/direct/v1',
      ),
      kongApiKey: const String.fromEnvironment('KONG_API_KEY'),
      azureClientId: const String.fromEnvironment('AZURE_CLIENT_ID'),
      azureTenantId: const String.fromEnvironment('AZURE_TENANT_ID'),
      azureB2cPolicySignIn: const String.fromEnvironment(
        'AZURE_B2C_POLICY_SIGN_IN',
        defaultValue: 'B2C_1_SignUpSignIn',
      ),
      azureB2cPolicyReset: const String.fromEnvironment(
        'AZURE_B2C_POLICY_RESET',
        defaultValue: 'B2C_1_PasswordReset',
      ),
      azureRedirectUri: const String.fromEnvironment(
        'AZURE_REDIRECT_URI',
        defaultValue: 'picklesdirect://auth',
      ),
      firebaseProjectId: const String.fromEnvironment(
        'FIREBASE_PROJECT_ID',
        defaultValue: 'pickles-direct-dev',
      ),
      sentinelPinCertHash: const String.fromEnvironment('CERT_PIN_HASH'),
      featureFlagsUrl: const String.fromEnvironment(
        'FEATURE_FLAGS_URL',
        defaultValue: 'https://api-dev.pickles.com.au/direct/v1/config/flags',
      ),
    );
  }

  final AppEnvironment environment;
  final String middlewareBaseUrl;
  final String kongApiKey;
  final String azureClientId;
  final String azureTenantId;
  final String azureB2cPolicySignIn;
  final String azureB2cPolicyReset;
  final String azureRedirectUri;
  final String firebaseProjectId;

  /// SHA-256 hash of the middleware TLS certificate leaf for cert pinning.
  final String sentinelPinCertHash;
  final String featureFlagsUrl;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isProduction => environment == AppEnvironment.production;

  /// Singleton resolved once at app start via [AppConfig.fromEnvironment].
  static late final AppConfig instance;
}
