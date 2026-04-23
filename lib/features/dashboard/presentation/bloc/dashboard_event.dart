part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

/// Starts the dashboard data streams. Dispatched when the page is mounted.
final class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

/// Triggers an immediate sync attempt via [SyncEngine.syncNow].
final class DashboardSyncRequested extends DashboardEvent {
  const DashboardSyncRequested();
}

// ── Internal events (emitted by stream subscriptions) ─────────────────────────

final class _ItemsReceived extends DashboardEvent {
  const _ItemsReceived(this.items);
  final List<SubmissionSummary> items;
  @override
  List<Object?> get props => [items];
}

final class _ItemsErrorReceived extends DashboardEvent {
  const _ItemsErrorReceived(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

final class _SyncStatusReceived extends DashboardEvent {
  const _SyncStatusReceived(this.syncStatus);
  final SyncStatus syncStatus;
  @override
  List<Object?> get props => [syncStatus];
}
