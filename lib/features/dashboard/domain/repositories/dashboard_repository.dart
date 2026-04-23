import 'package:pickles_direct/features/dashboard/domain/entities/submission_summary.dart';

/// Provides a live stream of all submission summaries for the current vendor.
///
/// Combines local drafts (from the `SubmissionDrafts` and `SyncQueue` tables)
/// with server-confirmed assets (from the `SubmittedAssets` table), sorted by
/// most recently updated first.
abstract interface class DashboardRepository {
  /// Emits a new list whenever any underlying table changes.
  Stream<List<SubmissionSummary>> watchAllItems();
}
