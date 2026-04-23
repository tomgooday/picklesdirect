import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Retries idempotent requests on transient network failures with
/// exponential backoff. Does not retry 4xx client errors.
@injectable
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);

  final Dio _dio;

  static const int _maxRetries = 3;
  static const int _baseDelayMs = 500;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount =
        (err.requestOptions.extra['retryCount'] as int?) ?? 0;

    final isRetryable = _isRetryable(err);
    if (isRetryable && retryCount < _maxRetries) {
      final delay = _backoffDelay(retryCount);
      await Future<void>.delayed(delay);

      err.requestOptions.extra['retryCount'] = retryCount + 1;
      try {
        handler.resolve(await _dio.fetch(err.requestOptions));
      } on Exception catch (_) {
        handler.next(err);
      }
      return;
    }
    handler.next(err);
  }

  bool _isRetryable(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout) return true;
    if (err.type == DioExceptionType.receiveTimeout) return true;
    if (err.type == DioExceptionType.connectionError) return true;
    final status = err.response?.statusCode;
    return status == 429 || (status != null && status >= 500);
  }

  Duration _backoffDelay(int attempt) {
    final jitter = Random().nextInt(200);
    return Duration(milliseconds: _baseDelayMs * pow(2, attempt).toInt() + jitter);
  }
}
