import 'package:equatable/equatable.dart';

/// Unified display model for an asset submission, regardless of whether it
/// lives locally as a draft or has been confirmed by the server.
final class SubmissionSummary extends Equatable {
  const SubmissionSummary({
    required this.id,
    required this.assetLabel,
    required this.assetCategory,
    required this.status,
    required this.updatedAt,
    this.remoteId,
    this.photoCount,
    this.lastSyncError,
  });

  final String id;
  final String assetLabel;
  final String assetCategory;
  final SubmissionStatus status;

  /// Most recent relevant timestamp — `updatedAt` for drafts, `lastUpdatedAt`
  /// for server-confirmed assets. Used for sort order on the dashboard list.
  final DateTime updatedAt;

  /// Server-assigned identifier. `null` for local drafts that have not yet
  /// been uploaded.
  final String? remoteId;

  /// Number of photos attached to the draft. `null` for submitted assets.
  final int? photoCount;

  /// Last sync error message, if [status] is [SubmissionStatus.syncFailed].
  final String? lastSyncError;

  bool get isLocal => status.isLocal;
  bool get hasValuation =>
      status == SubmissionStatus.accepted || status == SubmissionStatus.listed;

  @override
  List<Object?> get props => [
    id,
    assetLabel,
    assetCategory,
    status,
    updatedAt,
    remoteId,
    photoCount,
    lastSyncError,
  ];
}

/// All possible states a submission can be in, spanning local draft lifecycle
/// and server-side CRM workflow.
enum SubmissionStatus {
  /// Saved locally only; not yet queued for upload.
  draft,

  /// In the sync queue waiting for connectivity.
  queued,

  /// Currently being uploaded to the middleware.
  syncing,

  /// Upload failed after max retries; awaiting manual retry.
  syncFailed,

  /// Successfully uploaded; awaiting Pickles triage.
  submitted,

  /// Under review by Pickles valuers.
  valuationPending,

  /// Valuation accepted; asset will be listed.
  accepted,

  /// Asset is live on the auction platform.
  listed;

  /// Whether this status represents a locally-held draft (not yet on server).
  bool get isLocal =>
      this == draft || this == queued || this == syncing || this == syncFailed;

  /// Human-readable label shown in status chips.
  String get displayLabel => switch (this) {
    draft => 'Draft',
    queued => 'Queued',
    syncing => 'Syncing',
    syncFailed => 'Sync Failed',
    submitted => 'Submitted',
    valuationPending => 'Valuation Pending',
    accepted => 'Accepted',
    listed => 'Listed',
  };

  /// Derives a [SubmissionStatus] from the `syncStatus` string stored in the
  /// `SyncQueue` database table.
  static SubmissionStatus fromSyncQueueStatus(String? rawStatus) =>
      switch (rawStatus) {
        'pending' => SubmissionStatus.queued,
        'in_progress' => SubmissionStatus.syncing,
        'failed' => SubmissionStatus.syncFailed,
        _ => SubmissionStatus.draft,
      };

  /// Derives a [SubmissionStatus] from the `status` string in the
  /// `SubmittedAssets` database table (sourced from the CRM).
  static SubmissionStatus fromCrmStatus(String rawStatus) =>
      switch (rawStatus.toLowerCase()) {
        'valuation_pending' => SubmissionStatus.valuationPending,
        'accepted' => SubmissionStatus.accepted,
        'listed' => SubmissionStatus.listed,
        _ => SubmissionStatus.submitted,
      };
}
