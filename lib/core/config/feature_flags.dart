import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';

/// Lightweight feature flag service.
///
/// Flags are fetched from the middleware config endpoint on app start and
/// cached locally. This allows Pickles to toggle capabilities without an
/// app release (SC-13 extensibility requirement).
///
/// Usage:
/// ```dart
/// if (getIt<FeatureFlags>().isEnabled(AppConstants.flagBarcodeScanning)) {
///   // show barcode scanner
/// }
/// ```
abstract interface class FeatureFlags {
  bool isEnabled(String key);
  Future<void> refresh();
  void seed(Map<String, bool> flags);
}

@LazySingleton(as: FeatureFlags)
class FeatureFlagsImpl implements FeatureFlags {
  FeatureFlagsImpl(this._flagsRepository);

  final FlagsRepository _flagsRepository;

  final Map<String, bool> _cache = {
    // Safe defaults — all flags off until fetched from server.
    AppConstants.flagBarcodeScanning: false,
    AppConstants.flagPhotoGalleryImport: false,
    AppConstants.flagMeteredDataWarning: false,
    AppConstants.flagDuplicateSerialCheck: true,
  };

  @override
  bool isEnabled(String key) => _cache[key] ?? false;

  @override
  Future<void> refresh() async {
    final remoteFlags = await _flagsRepository.fetchFlags();
    _cache.addAll(remoteFlags);
  }

  @override
  void seed(Map<String, bool> flags) => _cache.addAll(flags);
}

/// Implemented in the data layer — calls the middleware config endpoint.
abstract interface class FlagsRepository {
  Future<Map<String, bool>> fetchFlags();
}
