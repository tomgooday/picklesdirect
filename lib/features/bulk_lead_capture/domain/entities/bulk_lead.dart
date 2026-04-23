import 'package:equatable/equatable.dart';

/// A Bulk Lead Capture submission (BR-07A–BR-07G, SOW v1.4).
///
/// Lightweight lead form for vendors with 2+ assets. Captured fields are a
/// subset of the Long Form — no photos, serial numbers, condition, or GPS.
/// Routed to AutoCheck with origin flag "Bulk Lead" for manual triage.
final class BulkLead extends Equatable {
  const BulkLead({
    required this.id,
    required this.vendorName,
    required this.phone,
    required this.email,
    required this.assetItems,
    this.status = BulkLeadStatus.draft,
    this.submittedAt,
  });

  final String id;
  final String vendorName;
  final String phone;
  final String email;

  /// One entry per selected asset type. Min 1 item.
  final List<BulkLeadAssetItem> assetItems;

  final BulkLeadStatus status;
  final DateTime? submittedAt;

  bool get isReadyToSubmit =>
      vendorName.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      assetItems.isNotEmpty &&
      assetItems.every((item) => item.isValid);

  BulkLead copyWith({
    String? vendorName,
    String? phone,
    String? email,
    List<BulkLeadAssetItem>? assetItems,
    BulkLeadStatus? status,
    DateTime? submittedAt,
  }) =>
      BulkLead(
        id: id,
        vendorName: vendorName ?? this.vendorName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        assetItems: assetItems ?? this.assetItems,
        status: status ?? this.status,
        submittedAt: submittedAt ?? this.submittedAt,
      );

  @override
  List<Object?> get props =>
      [id, vendorName, phone, email, assetItems, status, submittedAt];
}

/// A single asset type entry within a [BulkLead].
///
/// Maps to one row of the multi-select asset type list (BR-07A, BR-07B).
final class BulkLeadAssetItem extends Equatable {
  const BulkLeadAssetItem({
    required this.assetTypeKey,
    required this.assetTypeLabel,
    required this.quantity,
    this.make,
    this.model,
  });

  /// Schema key, e.g. "excavator" | "trucks" | "trailers".
  final String assetTypeKey;

  /// Human-readable label for display.
  final String assetTypeLabel;

  /// Approximate quantity for this asset type (BR-07E).
  final int quantity;

  /// Selected or typed make/manufacturer (BR-07C).
  final String? make;

  /// Selected or typed model (BR-07D).
  final String? model;

  /// An item is valid if it has a type selected and quantity ≥ 1.
  bool get isValid => assetTypeKey.isNotEmpty && quantity >= 1;

  BulkLeadAssetItem copyWith({
    String? assetTypeKey,
    String? assetTypeLabel,
    int? quantity,
    String? make,
    String? model,
  }) =>
      BulkLeadAssetItem(
        assetTypeKey: assetTypeKey ?? this.assetTypeKey,
        assetTypeLabel: assetTypeLabel ?? this.assetTypeLabel,
        quantity: quantity ?? this.quantity,
        make: make ?? this.make,
        model: model ?? this.model,
      );

  @override
  List<Object?> get props =>
      [assetTypeKey, assetTypeLabel, quantity, make, model];
}

enum BulkLeadStatus {
  draft,
  submitting,
  submitted,
  failed;
}
