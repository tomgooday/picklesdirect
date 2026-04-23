import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
/// Failures are returned via `Either` (dartz) — never thrown.
sealed class Failure extends Equatable {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

// ── Network ───────────────────────────────────────────────────────────────────

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.', super.code});
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code, this.statusCode});
  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'The request timed out.', super.code});
}

// ── Authentication ────────────────────────────────────────────────────────────

final class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

final class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = 'Your session has expired. Please log in again.',
  });
}

final class AccountSuspendedFailure extends Failure {
  const AccountSuspendedFailure({required super.message, super.code});
}

// ── Local Storage ─────────────────────────────────────────────────────────────

final class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}

final class EncryptionFailure extends Failure {
  const EncryptionFailure({
    super.message = 'Failed to encrypt or decrypt data.',
    super.code,
  });
}

// ── Validation ────────────────────────────────────────────────────────────────

final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, this.field, super.code});
  final String? field;

  @override
  List<Object?> get props => [...super.props, field];
}

// ── Asset Capture ─────────────────────────────────────────────────────────────

final class PhotoValidationFailure extends Failure {
  const PhotoValidationFailure({required super.message, super.code});
}

final class GpsFailure extends Failure {
  const GpsFailure({required super.message, super.code});
}

final class DuplicateSerialFailure extends Failure {
  const DuplicateSerialFailure({
    super.message =
        'Duplicate serial number detected — are you sure this is a different asset?',
    super.code,
  });
}

final class DraftLimitExceededFailure extends Failure {
  const DraftLimitExceededFailure({
    super.message =
        'You have reached the maximum of 50 draft submissions. Please sync or delete drafts before adding more.',
  });
}

// ── Sync ──────────────────────────────────────────────────────────────────────

final class SyncFailure extends Failure {
  const SyncFailure({required super.message, super.code, this.retryCount = 0});
  final int retryCount;

  @override
  List<Object?> get props => [...super.props, retryCount];
}

final class MaxRetriesExceededFailure extends Failure {
  const MaxRetriesExceededFailure({
    super.message =
        'Unable to sync after multiple attempts. Please check your connection and try again.',
  });
}

// ── Device ────────────────────────────────────────────────────────────────────

final class DeviceTimeDriftFailure extends Failure {
  const DeviceTimeDriftFailure({
    super.message =
        'Your device clock is out of sync. Please correct your device time to continue.',
  });
}

// ── Unexpected ────────────────────────────────────────────────────────────────

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code,
  });
}
