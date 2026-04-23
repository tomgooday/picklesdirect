part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded({required this.items, required this.syncStatus});

  final List<SubmissionSummary> items;
  final SyncStatus syncStatus;

  /// Local drafts — shown in the "Drafts" section.
  List<SubmissionSummary> get drafts => items.where((i) => i.isLocal).toList();

  /// Server-confirmed assets — shown in the "Submitted" section.
  List<SubmissionSummary> get submitted =>
      items.where((i) => !i.isLocal).toList();

  bool get isEmpty => items.isEmpty;

  DashboardLoaded copyWith({
    List<SubmissionSummary>? items,
    SyncStatus? syncStatus,
  }) => DashboardLoaded(
    items: items ?? this.items,
    syncStatus: syncStatus ?? this.syncStatus,
  );

  @override
  List<Object?> get props => [items, syncStatus];
}

final class DashboardError extends DashboardState {
  const DashboardError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
