import 'dart:async' show StreamSubscription, unawaited;
import 'dart:math';

// unawaited is available from dart:async in Dart 3+

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/network/network_info.dart';
import 'package:rxdart/rxdart.dart';

enum SyncStatus { idle, syncing, failed, completed }

/// Sync engine coordinates offline-to-online submission upload.
///
/// Responsibilities:
///   - Monitors connectivity and triggers sync when connection is restored.
///   - Processes the queue sequentially (one item at a time).
///   - Exponential backoff with jitter on failure (max [AppConstants.syncMaxRetryAttempts]).
///   - Emits [SyncStatus] events consumed by the UI sync badge.
///   - Allows manual trigger via [syncNow].
///
/// Concrete upload logic lives in [SubmissionSyncService], injected here
/// to keep the engine testable in isolation.
abstract interface class SyncEngine {
  Stream<SyncStatus> get statusStream;
  SyncStatus get currentStatus;
  Future<void> syncNow();
  Future<void> start();
  void stop();
}

@LazySingleton(as: SyncEngine)
class SyncEngineImpl implements SyncEngine {
  SyncEngineImpl(this._networkInfo, this._submissionSyncService, this._logger);

  final NetworkInfo _networkInfo;
  final SubmissionSyncService _submissionSyncService;
  final Logger _logger;

  final _statusSubject = BehaviorSubject<SyncStatus>.seeded(SyncStatus.idle);
  StreamSubscription<bool>? _connectivitySub;
  bool _isSyncing = false;

  @override
  Stream<SyncStatus> get statusStream => _statusSubject.stream;

  @override
  SyncStatus get currentStatus => _statusSubject.value;

  @override
  Future<void> start() async {
    unawaited(_connectivitySub?.cancel());
    _connectivitySub = _networkInfo.onConnectivityChanged.listen((connected) {
      if (connected && !_isSyncing) {
        _logger.i('[SyncEngine] Connectivity restored — triggering sync.');
        unawaited(syncNow());
      }
    });

    // Attempt sync immediately on start if connected.
    if (await _networkInfo.isConnected) {
      await syncNow();
    }
  }

  @override
  void stop() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  @override
  Future<void> syncNow() async {
    if (_isSyncing) return;
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      _logger.w('[SyncEngine] syncNow called but device is offline.');
      return;
    }

    _isSyncing = true;
    _statusSubject.add(SyncStatus.syncing);

    try {
      await _submissionSyncService.processQueue();
      _statusSubject.add(SyncStatus.completed);
      _logger.i('[SyncEngine] Sync completed successfully.');
    } on Exception catch (e, st) {
      _statusSubject.add(SyncStatus.failed);
      _logger.e('[SyncEngine] Sync failed.', error: e, stackTrace: st);
    } finally {
      _isSyncing = false;
      // Return to idle after brief completed/failed state.
      await Future<void>.delayed(const Duration(seconds: 3));
      if (_statusSubject.value != SyncStatus.syncing) {
        _statusSubject.add(SyncStatus.idle);
      }
    }
  }

  /// Calculates exponential backoff with jitter.
  /// Returns exponential backoff with jitter for the given [attempt] (0-based).
  static Duration backoffDelay(int attempt) {
    const base = AppConstants.syncRetryBaseDelaySeconds;
    final jitter = Random().nextInt(5);
    final seconds = (base * pow(2, attempt)).clamp(base, 300).toInt() + jitter;
    return Duration(seconds: seconds);
  }
}

/// Interface for the service that performs the actual API calls.
/// Implemented in the sync_queue feature layer.
abstract interface class SubmissionSyncService {
  Future<void> processQueue();
}
