import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/sync/sync_engine.dart';
import 'package:pickles_direct/features/dashboard/domain/entities/submission_summary.dart';
import 'package:pickles_direct/features/dashboard/domain/usecases/watch_dashboard_items.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._watchDashboardItems, this._syncEngine)
    : super(const DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardSyncRequested>(_onSyncRequested);
    on<_ItemsReceived>(_onItemsReceived);
    on<_ItemsErrorReceived>(_onItemsErrorReceived);
    on<_SyncStatusReceived>(_onSyncStatusReceived);
  }

  final WatchDashboardItems _watchDashboardItems;
  final SyncEngine _syncEngine;

  StreamSubscription<List<SubmissionSummary>>? _itemsSub;
  StreamSubscription<SyncStatus>? _syncStatusSub;

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    await _itemsSub?.cancel();
    _itemsSub = _watchDashboardItems().listen(
      (items) => add(_ItemsReceived(items)),
      onError: (Object e) => add(
        const _ItemsErrorReceived(
          'Unable to load submissions. Please try again.',
        ),
      ),
    );

    await _syncStatusSub?.cancel();
    _syncStatusSub = _syncEngine.statusStream.listen(
      (status) => add(_SyncStatusReceived(status)),
    );
  }

  Future<void> _onSyncRequested(
    DashboardSyncRequested event,
    Emitter<DashboardState> emit,
  ) async {
    // Fire-and-forget — SyncEngine emits status updates through statusStream.
    // ignore: unawaited_futures
    _syncEngine.syncNow();
  }

  void _onItemsReceived(_ItemsReceived event, Emitter<DashboardState> emit) {
    final current = state;
    emit(
      DashboardLoaded(
        items: event.items,
        syncStatus: current is DashboardLoaded
            ? current.syncStatus
            : _syncEngine.currentStatus,
      ),
    );
  }

  void _onItemsErrorReceived(
    _ItemsErrorReceived event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardError(message: event.message));
  }

  void _onSyncStatusReceived(
    _SyncStatusReceived event,
    Emitter<DashboardState> emit,
  ) {
    final current = state;
    if (current is DashboardLoaded) {
      emit(current.copyWith(syncStatus: event.syncStatus));
    }
  }

  @override
  Future<void> close() async {
    await _itemsSub?.cancel();
    await _syncStatusSub?.cancel();
    return super.close();
  }
}
