import 'package:equatable/equatable.dart';

/// A single compressed photo attached to an asset draft.
///
/// Persisted in the SubmissionPhotos Drift table. The [localPath] points to
/// the compressed JPEG on device storage; it is uploaded to the middleware
/// when the draft is synced.
final class SubmissionPhoto extends Equatable {
  const SubmissionPhoto({
    required this.id,
    required this.submissionId,
    required this.categoryKey,
    required this.categoryLabel,
    required this.localPath,
    required this.originalFilename,
    required this.fileSizeBytes,
    required this.widthPx,
    required this.heightPx,
    required this.sortOrder,
    required this.capturedAt,
    this.gpsLat,
    this.gpsLng,
  });

  final String id;
  final String submissionId;

  /// Maps to a PhotoCategory key.
  final String categoryKey;
  final String categoryLabel;

  /// Absolute path to the compressed JPEG on device storage.
  final String localPath;
  final String originalFilename;
  final int fileSizeBytes;
  final int widthPx;
  final int heightPx;
  final int sortOrder;
  final DateTime capturedAt;
  final double? gpsLat;
  final double? gpsLng;

  SubmissionPhoto copyWith({int? sortOrder}) => SubmissionPhoto(
    id: id,
    submissionId: submissionId,
    categoryKey: categoryKey,
    categoryLabel: categoryLabel,
    localPath: localPath,
    originalFilename: originalFilename,
    fileSizeBytes: fileSizeBytes,
    widthPx: widthPx,
    heightPx: heightPx,
    sortOrder: sortOrder ?? this.sortOrder,
    capturedAt: capturedAt,
    gpsLat: gpsLat,
    gpsLng: gpsLng,
  );

  @override
  List<Object?> get props => [
    id,
    submissionId,
    categoryKey,
    sortOrder,
    localPath,
    fileSizeBytes,
  ];
}
