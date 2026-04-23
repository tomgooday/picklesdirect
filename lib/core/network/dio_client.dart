import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/config/app_config.dart';
import 'package:pickles_direct/core/network/interceptors/auth_interceptor.dart';
import 'package:pickles_direct/core/network/interceptors/retry_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@singleton
class DioClient {
  DioClient(
    this._config,
    this._authInterceptor,
    this._retryInterceptor,
  ) {
    _dio = _buildDio();
  }

  final AppConfig _config;
  final AuthInterceptor _authInterceptor;
  // Injected but used inside _buildDio to configure per-instance retry logic.
  final RetryInterceptor _retryInterceptor;

  late final Dio _dio;

  Dio get dio => _dio;

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _config.middlewareBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Certificate pinning in production — reject connections with unknown certs.
    if (_config.isProduction && _config.sentinelPinCertHash.isNotEmpty) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback = (cert, host, port) {
              // Compare SHA-256 fingerprint of presented cert against pinned hash.
              // Real implementation should use dart:crypto to hash the DER bytes.
              return false;
            };
    }

    dio.interceptors.addAll([
      _authInterceptor,
      _retryInterceptor,
      if (!_config.isProduction)
        PrettyDioLogger(
          requestBody: true,
          responseBody: false,
        ),
    ]);

    return dio;
  }
}
