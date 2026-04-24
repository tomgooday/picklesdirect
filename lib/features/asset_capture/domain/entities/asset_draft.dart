import 'package:equatable/equatable.dart';

enum DraftStatus { draft, queued, syncing, submitted }

/// A locally-stored vendor asset submission draft.
///
/// [fieldValues] is a flat `Map<String, dynamic>` keyed by field schema key.
/// It is JSON-encoded and AES-256-GCM encrypted before being written to the
/// SubmissionDrafts Drift table.
final class AssetDraft extends Equatable {
  const AssetDraft({
    required this.id,
    required this.vendorId,
    required this.categoryKey,
    required this.assetLabel,
    required this.fieldValues,
    required this.createdAt,
    required this.updatedAt,
    this.gpsLat,
    this.gpsLng,
    this.photoCount = 0,
    this.status = DraftStatus.draft,
  });

  final String id;
  final String vendorId;
  final String categoryKey;

  /// Human-readable summary label (e.g. "2018 Caterpillar 320").
  final String assetLabel;

  final Map<String, dynamic> fieldValues;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? gpsLat;
  final double? gpsLng;
  final int photoCount;
  final DraftStatus status;

  AssetDraft copyWith({
    String? categoryKey,
    String? assetLabel,
    Map<String, dynamic>? fieldValues,
    double? gpsLat,
    double? gpsLng,
    int? photoCount,
    DraftStatus? status,
    DateTime? updatedAt,
  }) => AssetDraft(
    id: id,
    vendorId: vendorId,
    categoryKey: categoryKey ?? this.categoryKey,
    assetLabel: assetLabel ?? this.assetLabel,
    fieldValues: fieldValues ?? this.fieldValues,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    gpsLat: gpsLat ?? this.gpsLat,
    gpsLng: gpsLng ?? this.gpsLng,
    photoCount: photoCount ?? this.photoCount,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [
    id,
    vendorId,
    categoryKey,
    assetLabel,
    fieldValues,
    createdAt,
    updatedAt,
    gpsLat,
    gpsLng,
    photoCount,
    status,
  ];
}
