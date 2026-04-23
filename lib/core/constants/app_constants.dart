/// Application-wide constants for Pickles Direct.
library;

class AppConstants {
  AppConstants._();

  // ── Branding ──────────────────────────────────────────────────────────────
  static const String appName = 'Pickles Direct';
  static const String tagline = 'Upload. Offload.';
  static const String supportEmail = 'direct@pickles.com.au';
  static const String supportPhone = '1300 052 392';
  static const String picklesWebsite = 'https://www.pickles.com.au';
  static const String privacyPolicyUrl =
      'https://www.pickles.com.au/privacy-policy';
  static const String termsUrl =
      'https://www.pickles.com.au/terms-and-conditions';
  static const String faqUrl = 'https://www.pickles.com.au/direct/faq';

  // ── Terms & Conditions ────────────────────────────────────────────────────
  /// Bump this when T&C content changes to force re-acceptance (BRU-18).
  static const String termsVersion = '1.0';

  // ── Session & Auth ────────────────────────────────────────────────────────
  /// Inactivity timeout before session expiry (minutes).
  static const int sessionTimeoutMinutes = 30;

  /// Maximum session duration across reconnects (days).
  static const int persistentSessionDays = 30;

  // ── Asset Capture ─────────────────────────────────────────────────────────
  static const int photoMinCount = 8;
  static const int photoMaxCount = 20;
  static const int photoMaxSizeBytes = 10 * 1024 * 1024; // 10 MB
  static const int photoTargetSizeBytes = 500 * 1024; // 500 KB
  static const int photoJpegQuality = 80;
  static const int photoMinWidthPx = 800;
  static const int photoMinHeightPx = 600;
  static const int photoRecommendedWidthPx = 1920;
  static const int photoRecommendedHeightPx = 1080;
  static const int submissionMaxSizeBytes = 150 * 1024 * 1024; // 150 MB

  static const int assetDescriptionMaxChars = 500;
  static const int maxDraftSubmissions = 50;

  // ── Sync ──────────────────────────────────────────────────────────────────
  static const int syncMaxRetryAttempts = 5;
  static const int syncRetryBaseDelaySeconds = 10;
  static const int syncSlaSeconds = 120; // 2 min SLA for full asset sync

  // ── Validation ────────────────────────────────────────────────────────────
  static const int manufactureYearMin = 1950;
  static const int vinMinLength = 6;
  static const int vinModernLength = 17;
  static const int serialMinLength = 6;
  static const int serialMaxLength = 50;
  static const int odometerWarningThreshold = 2000000; // km
  static const int engineHoursWarningThreshold = 100000;
  static const int highValueFlagThreshold = 100000; // AUD

  // ── Geography (Australia bounding box) ───────────────────────────────────
  static const double gpsLatMin = -44;
  static const double gpsLatMax = -10;
  static const double gpsLngMin = 113;
  static const double gpsLngMax = 154;

  // ── Device time ───────────────────────────────────────────────────────────
  /// Max allowed drift between device time and server time.
  static const int deviceTimeDriftLimitHours = 24;

  // ── Storage keys ─────────────────────────────────────────────────────────
  static const String storageKeyAuthToken = 'auth_access_token';
  static const String storageKeyRefreshToken = 'auth_refresh_token';
  static const String storageKeyUserId = 'auth_user_id';
  static const String storageKeyTcVersion = 'accepted_tc_version';
  static const String storageKeyPrivacyVersion = 'accepted_privacy_version';
  static const String storageKeyOnboardingComplete = 'onboarding_complete';
  static const String storageKeySchemaVersion = 'asset_schema_version';

  // ── Database ──────────────────────────────────────────────────────────────
  static const String databaseName = 'pickles_direct.db';
  static const int databaseVersion = 1;

  // ── Feature flag keys ─────────────────────────────────────────────────────
  static const String flagBarcodeScanning = 'feature_barcode_scanning';
  static const String flagPhotoGalleryImport = 'feature_photo_gallery_import';
  static const String flagMeteredDataWarning = 'feature_metered_data_warning';
  static const String flagDuplicateSerialCheck = 'feature_duplicate_serial';
}
