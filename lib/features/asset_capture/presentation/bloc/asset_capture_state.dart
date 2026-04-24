part of 'asset_capture_bloc.dart';

enum GpsStatus { idle, fetching, success, error }

enum DraftSaveStatus { idle, saving, saved, error }

enum FormSubmitStatus { idle, submitting, success, error }

final class AssetCaptureState extends Equatable {
  const AssetCaptureState({
    required this.status,
    this.category,
    this.draftId,
    this.fieldValues = const {},
    this.validationErrors = const {},
    this.gpsStatus = GpsStatus.idle,
    this.locationAddress,
    this.gpsLat,
    this.gpsLng,
    this.saveStatus = DraftSaveStatus.idle,
    this.submitStatus = FormSubmitStatus.idle,
    this.failure,
  });

  factory AssetCaptureState.initial() =>
      const AssetCaptureState(status: AssetCaptureStatus.initial);

  final AssetCaptureStatus status;
  final AssetCategory? category;

  /// Drift row ID of the current draft (null for a brand-new form).
  final String? draftId;

  /// Flat map of field key → current value.
  final Map<String, dynamic> fieldValues;

  /// Per-field validation error messages (field key → message).
  final Map<String, String> validationErrors;

  final GpsStatus gpsStatus;
  final String? locationAddress;
  final double? gpsLat;
  final double? gpsLng;

  final DraftSaveStatus saveStatus;
  final FormSubmitStatus submitStatus;
  final Failure? failure;

  bool get isLoaded => status == AssetCaptureStatus.loaded;
  bool get hasValidationErrors => validationErrors.isNotEmpty;

  AssetCaptureState copyWith({
    AssetCaptureStatus? status,
    AssetCategory? category,
    String? draftId,
    Map<String, dynamic>? fieldValues,
    Map<String, String>? validationErrors,
    GpsStatus? gpsStatus,
    String? locationAddress,
    double? gpsLat,
    double? gpsLng,
    DraftSaveStatus? saveStatus,
    FormSubmitStatus? submitStatus,
    Failure? failure,
  }) => AssetCaptureState(
    status: status ?? this.status,
    category: category ?? this.category,
    draftId: draftId ?? this.draftId,
    fieldValues: fieldValues ?? this.fieldValues,
    validationErrors: validationErrors ?? this.validationErrors,
    gpsStatus: gpsStatus ?? this.gpsStatus,
    locationAddress: locationAddress ?? this.locationAddress,
    gpsLat: gpsLat ?? this.gpsLat,
    gpsLng: gpsLng ?? this.gpsLng,
    saveStatus: saveStatus ?? this.saveStatus,
    submitStatus: submitStatus ?? this.submitStatus,
    failure: failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    category,
    draftId,
    fieldValues,
    validationErrors,
    gpsStatus,
    locationAddress,
    gpsLat,
    gpsLng,
    saveStatus,
    submitStatus,
    failure,
  ];
}

enum AssetCaptureStatus { initial, loading, loaded, error }
