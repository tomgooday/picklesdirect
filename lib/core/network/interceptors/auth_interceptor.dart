import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/security/token_storage.dart';

/// Attaches the Bearer token to every outbound request and silently
/// refreshes it on 401 responses (single-shot refresh; no parallel storm).
@injectable
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['X-Api-Key'] = options.extra['kongApiKey'] as String? ?? '';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      if (_isRefreshing) {
        _pendingRequests.add(err.requestOptions);
        return;
      }
      _isRefreshing = true;
      try {
        await _tokenStorage.refreshTokens();
        final token = await _tokenStorage.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        handler.resolve(await Dio().fetch(err.requestOptions));
      } on Exception catch (_) {
        await _tokenStorage.clearTokens();
        handler.reject(err);
      } finally {
        _isRefreshing = false;
        _pendingRequests.clear();
      }
      return;
    }
    handler.next(err);
  }
}
