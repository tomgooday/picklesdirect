part of 'bulk_lead_bloc.dart';

sealed class BulkLeadEvent extends Equatable {
  const BulkLeadEvent();
  @override
  List<Object?> get props => [];
}

/// Vendor contact detail field changed.
final class BulkLeadVendorDetailsChanged extends BulkLeadEvent {
  const BulkLeadVendorDetailsChanged({
    this.vendorName,
    this.phone,
    this.email,
  });
  final String? vendorName;
  final String? phone;
  final String? email;

  @override
  List<Object?> get props => [vendorName, phone, email];
}

/// An asset type checkbox toggled on or off (BR-07A, BR-07B).
final class BulkLeadAssetTypeToggled extends BulkLeadEvent {
  const BulkLeadAssetTypeToggled({
    required this.assetTypeKey,
    required this.assetTypeLabel,
  });
  final String assetTypeKey;
  final String assetTypeLabel;

  @override
  List<Object?> get props => [assetTypeKey, assetTypeLabel];
}

/// Make, model, or quantity changed for a specific asset type (BR-07C, BR-07D, BR-07E).
final class BulkLeadAssetItemUpdated extends BulkLeadEvent {
  const BulkLeadAssetItemUpdated({
    required this.assetTypeKey,
    this.quantity,
    this.make,
    this.model,
  });
  final String assetTypeKey;
  final int? quantity;
  final String? make;
  final String? model;

  @override
  List<Object?> get props => [assetTypeKey, quantity, make, model];
}

/// User tapped Submit.
final class BulkLeadSubmitRequested extends BulkLeadEvent {
  const BulkLeadSubmitRequested();
}

/// Reset form back to initial state.
final class BulkLeadReset extends BulkLeadEvent {
  const BulkLeadReset();
}
