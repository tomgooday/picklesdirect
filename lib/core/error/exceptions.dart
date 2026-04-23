/// Data-layer exceptions that are caught and mapped to `Failure` types
/// in repository implementations. Never leak past the data layer.
library;

class NetworkException implements Exception {
  const NetworkException({this.message, this.statusCode});
  final String? message;
  final int? statusCode;
}

class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode, this.code});
  final String message;
  final int? statusCode;
  final String? code;
}

class AuthException implements Exception {
  const AuthException({required this.message, this.code});
  final String message;
  final String? code;
}

class StorageException implements Exception {
  const StorageException({required this.message});
  final String message;
}

class EncryptionException implements Exception {
  const EncryptionException({this.message});
  final String? message;
}

class GpsException implements Exception {
  const GpsException({required this.message});
  final String message;
}

class SyncException implements Exception {
  const SyncException({required this.message, this.code});
  final String message;
  final String? code;
}

class ValidationException implements Exception {
  const ValidationException({required this.message, this.field});
  final String message;
  final String? field;
}
