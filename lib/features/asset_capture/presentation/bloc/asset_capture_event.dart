part of 'asset_capture_bloc.dart';

sealed class AssetCaptureEvent extends Equatable {
  const AssetCaptureEvent();
  @override
  List<Object?> get props => [];
}

/// Initialise the form for a given [categoryKey].
/// If [draftId] is provided, the existing draft is loaded into the form.
final class AssetCaptureStarted extends AssetCaptureEvent {
  const AssetCaptureStarted({required this.categoryKey, this.draftId});
  final String categoryKey;
  final String? draftId;

  @override
  List<Object?> get props => [categoryKey, draftId];
}

/// User changed a field value. [value] is `null` to clear the field.
final class AssetFieldChanged extends AssetCaptureEvent {
  const AssetFieldChanged({required this.fieldKey, required this.value});
  final String fieldKey;
  final dynamic value;

  @override
  List<Object?> get props => [fieldKey, value];
}

/// User tapped "Use My Location" — triggers GPS permission + lookup.
final class AssetGpsRequested extends AssetCaptureEvent {
  const AssetGpsRequested();
}

/// VIN / serial scanner returned a result.
final class AssetVinScanned extends AssetCaptureEvent {
  const AssetVinScanned({required this.targetFieldKey, required this.value});
  final String targetFieldKey;
  final String value;

  @override
  List<Object?> get props => [targetFieldKey, value];
}

/// Save current form state as a draft. Triggers immediately on user action
/// and auto-saves when the form is popped.
final class AssetDraftSaveRequested extends AssetCaptureEvent {
  const AssetDraftSaveRequested();
}

/// Validate the form and queue the draft for sync.
final class AssetFormSubmitRequested extends AssetCaptureEvent {
  const AssetFormSubmitRequested();
}
