import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/error/exceptions.dart';

/// Wraps [FlutterSecureStorage] to manage auth tokens.
/// Uses iOS Keychain and Android Keystore under the hood.
abstract interface class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> refreshTokens();
  Future<void> clearTokens();
}

@LazySingleton(as: TokenStorage)
class TokenStorageImpl implements TokenStorage {
  TokenStorageImpl(this._secureStorage, this._authService);

  final FlutterSecureStorage _secureStorage;

  // Injected late to avoid circular dependency — auth service uses token
  // storage; token storage calls auth service only for token refresh.
  final AuthRefreshService _authService;

  static const _iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  @override
  Future<String?> getAccessToken() => _secureStorage.read(
    key: AppConstants.storageKeyAuthToken,
    iOptions: _iOSOptions,
    aOptions: _androidOptions,
  );

  @override
  Future<String?> getRefreshToken() => _secureStorage.read(
    key: AppConstants.storageKeyRefreshToken,
    iOptions: _iOSOptions,
    aOptions: _androidOptions,
  );

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(
        key: AppConstants.storageKeyAuthToken,
        value: accessToken,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      ),
      _secureStorage.write(
        key: AppConstants.storageKeyRefreshToken,
        value: refreshToken,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      ),
    ]);
  }

  @override
  Future<void> refreshTokens() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw const AuthException(message: 'No refresh token available.');
    }
    final newTokens = await _authService.refresh(refreshToken);
    await saveTokens(
      accessToken: newTokens.accessToken,
      refreshToken: newTokens.refreshToken,
    );
  }

  @override
  Future<void> clearTokens() => Future.wait([
    _secureStorage.delete(
      key: AppConstants.storageKeyAuthToken,
      iOptions: _iOSOptions,
      aOptions: _androidOptions,
    ),
    _secureStorage.delete(
      key: AppConstants.storageKeyRefreshToken,
      iOptions: _iOSOptions,
      aOptions: _androidOptions,
    ),
  ]);
}

/// Minimal interface used by [TokenStorageImpl] to avoid circular DI.
abstract interface class AuthRefreshService {
  Future<({String accessToken, String refreshToken})> refresh(
    String refreshToken,
  );
}
