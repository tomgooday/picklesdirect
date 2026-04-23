import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/storage/database/app_database.dart';
import 'package:pickles_direct/features/dashboard/domain/entities/submission_summary.dart';
import 'package:pickles_direct/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<SubmissionSummary>> watchAllItems() {
    final draftsStream = (_db.select(_db.submissionDrafts)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();

    final syncQueueStream = _db.select(_db.syncQueue).watch();

    final submittedStream = (_db.select(_db.submittedAssets)
          ..orderBy([(t) => OrderingTerm.desc(t.lastUpdatedAt)]))
        .watch();

    return Rx.combineLatest3(
      draftsStream,
      syncQueueStream,
      submittedStream,
      (
        List<SubmissionDraft> drafts,
        List<SyncQueueData> syncEntries,
        List<SubmittedAsset> submittedAssets,
      ) =>
          _buildSummaries(
        drafts: drafts,
        syncEntries: syncEntries,
        submittedAssets: submittedAssets,
      ),
    );
  }

  List<SubmissionSummary> _buildSummaries({
    required List<SubmissionDraft> drafts,
    required List<SyncQueueData> syncEntries,
    required List<SubmittedAsset> submittedAssets,
  }) {
    // Index sync queue entries by submissionId for O(1) lookup.
    final syncMap = {
      for (final entry in syncEntries) entry.submissionId: entry,
    };

    final draftSummaries = drafts.map((draft) {
      final syncEntry = syncMap[draft.id];
      return SubmissionSummary(
        id: draft.id,
        assetLabel: draft.assetLabel,
        assetCategory: draft.assetCategory,
        status: SubmissionStatus.fromSyncQueueStatus(syncEntry?.syncStatus),
        updatedAt: draft.updatedAt,
        photoCount: draft.photoCount,
        lastSyncError: syncEntry?.lastErrorMessage,
      );
    });

    final submittedSummaries = submittedAssets.map((asset) {
      return SubmissionSummary(
        id: asset.id,
        assetLabel: asset.assetLabel,
        assetCategory: asset.assetCategory,
        status: SubmissionStatus.fromCrmStatus(asset.status),
        updatedAt: asset.lastUpdatedAt,
        remoteId: asset.remoteId,
      );
    });

    return [...draftSummaries, ...submittedSummaries]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }
}
