import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/asset_capture/data/datasources/asset_schema_service.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_category.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_draft.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_field_schema.dart';
import 'package:pickles_direct/features/asset_capture/domain/usecases/load_asset_draft.dart';
import 'package:pickles_direct/features/asset_capture/domain/usecases/save_asset_draft.dart';
import 'package:uuid/uuid.dart';

part 'asset_capture_event.dart';
part 'asset_capture_state.dart';

@injectable
class AssetCaptureBloc extends Bloc<AssetCaptureEvent, AssetCaptureState> {
  AssetCaptureBloc(
    this._saveAssetDraft,
    this._loadAssetDraft,
    this._secureStorage,
    this._log,
  ) : super(AssetCaptureState.initial()) {
    on<AssetCaptureStarted>(_onStarted);
    on<AssetFieldChanged>(_onFieldChanged);
    on<AssetGpsRequested>(_onGpsRequested);
    on<AssetVinScanned>(_onVinScanned);
    on<AssetDraftSaveRequested>(_onDraftSaveRequested);
    on<AssetFormSubmitRequested>(_onSubmitRequested);
  }

  final SaveAssetDraft _saveAssetDraft;
  final LoadAssetDraft _loadAssetDraft;

  // Used to read the stored user ID. Replace with AuthRepository.currentUser()
  // once AuthRepositoryImpl is wired.
  final FlutterSecureStorage _secureStorage;
  final Logger _log;

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onStarted(
    AssetCaptureStarted event,
    Emitter<AssetCaptureState> emit,
  ) async {
    emit(state.copyWith(status: AssetCaptureStatus.loading));

    final category = AssetSchemaService.categoryForKey(event.categoryKey);
    if (category == null) {
      emit(
        state.copyWith(
          status: AssetCaptureStatus.error,
          failure: UnexpectedFailure(
            message: 'Unknown category: ${event.categoryKey}',
          ),
        ),
      );
      return;
    }

    if (event.draftId != null) {
      final result = await _loadAssetDraft(event.draftId!);
      result.fold(
        (failure) => emit(
          state.copyWith(status: AssetCaptureStatus.error, failure: failure),
        ),
        (draft) {
          if (draft != null) {
            emit(
              state.copyWith(
                status: AssetCaptureStatus.loaded,
                category: category,
                draftId: draft.id,
                fieldValues: Map<String, dynamic>.from(draft.fieldValues),
                gpsLat: draft.gpsLat,
                gpsLng: draft.gpsLng,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: AssetCaptureStatus.loaded,
                category: category,
                draftId: event.draftId,
              ),
            );
          }
        },
      );
    } else {
      emit(
        state.copyWith(
          status: AssetCaptureStatus.loaded,
          category: category,
        ),
      );
    }
  }

  void _onFieldChanged(
    AssetFieldChanged event,
    Emitter<AssetCaptureState> emit,
  ) {
    final updated = Map<String, dynamic>.from(state.fieldValues);
    if (event.value == null) {
      updated.remove(event.fieldKey);
    } else {
      updated[event.fieldKey] = event.value;
    }

    // Clear the validation error for this field when it changes.
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove(event.fieldKey);

    emit(
      state.copyWith(
        fieldValues: updated,
        validationErrors: errors,
        saveStatus: DraftSaveStatus.idle,
      ),
    );
  }

  Future<void> _onGpsRequested(
    AssetGpsRequested event,
    Emitter<AssetCaptureState> emit,
  ) async {
    emit(state.copyWith(gpsStatus: GpsStatus.fetching));
    try {
      final permission = await Permission.locationWhenInUse.request();
      if (!permission.isGranted) {
        emit(state.copyWith(gpsStatus: GpsStatus.error));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // Validate the position is within Australia.
      if (position.latitude < AppConstants.gpsLatMin ||
          position.latitude > AppConstants.gpsLatMax ||
          position.longitude < AppConstants.gpsLngMin ||
          position.longitude > AppConstants.gpsLngMax) {
        _log.w('GPS position outside Australia: $position');
      }

      String? address;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          address = [
            p.street,
            p.locality,
            p.administrativeArea,
            p.postalCode,
          ].where((s) => s != null && s.isNotEmpty).join(', ');
        }
      } on Exception catch (e) {
        _log.w('Geocoding failed', error: e);
        address = '${position.latitude.toStringAsFixed(5)}, '
            '${position.longitude.toStringAsFixed(5)}';
      }

      final updatedFields = Map<String, dynamic>.from(state.fieldValues);
      if (address != null) updatedFields['location'] = address;

      emit(
        state.copyWith(
          gpsStatus: GpsStatus.success,
          gpsLat: position.latitude,
          gpsLng: position.longitude,
          locationAddress: address,
          fieldValues: updatedFields,
        ),
      );
    } on Exception catch (e) {
      _log.e('GPS failed', error: e);
      emit(state.copyWith(gpsStatus: GpsStatus.error));
    }
  }

  void _onVinScanned(
    AssetVinScanned event,
    Emitter<AssetCaptureState> emit,
  ) {
    final updated = Map<String, dynamic>.from(state.fieldValues)
      ..[event.targetFieldKey] = event.value;
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove(event.targetFieldKey);
    emit(state.copyWith(fieldValues: updated, validationErrors: errors));
  }

  Future<void> _onDraftSaveRequested(
    AssetDraftSaveRequested event,
    Emitter<AssetCaptureState> emit,
  ) async {
    if (state.category == null) return;
    emit(state.copyWith(saveStatus: DraftSaveStatus.saving));

    final vendorId =
        await _secureStorage.read(key: AppConstants.storageKeyUserId) ??
            'anonymous';
    final draftId = state.draftId ?? const Uuid().v4();
    final now = DateTime.now();

    final draft = AssetDraft(
      id: draftId,
      vendorId: vendorId,
      categoryKey: state.category!.key,
      assetLabel: _buildAssetLabel(state.category!, state.fieldValues),
      fieldValues: state.fieldValues,
      createdAt: now,
      updatedAt: now,
      gpsLat: state.gpsLat,
      gpsLng: state.gpsLng,
    );

    final result = await _saveAssetDraft(draft);
    result.fold(
      (failure) => emit(
        state.copyWith(saveStatus: DraftSaveStatus.error, failure: failure),
      ),
      (_) => emit(
        state.copyWith(saveStatus: DraftSaveStatus.saved, draftId: draftId),
      ),
    );
  }

  Future<void> _onSubmitRequested(
    AssetFormSubmitRequested event,
    Emitter<AssetCaptureState> emit,
  ) async {
    if (state.category == null) return;

    final errors = _validate(state.category!.fields, state.fieldValues);
    if (errors.isNotEmpty) {
      emit(state.copyWith(validationErrors: errors));
      return;
    }

    // Save draft first to ensure it's persisted, then queue for sync.
    emit(state.copyWith(submitStatus: FormSubmitStatus.submitting));
    await _onDraftSaveRequested(const AssetDraftSaveRequested(), emit);

    // Sync queuing is handled by SyncEngine watching the SubmissionDrafts
    // table. Once middleware spec is available, update status to 'queued'
    // here and SyncEngine will pick it up automatically.
    emit(state.copyWith(submitStatus: FormSubmitStatus.success));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Derives a human-readable label from the most identifiable fields.
  String _buildAssetLabel(
    AssetCategory category,
    Map<String, dynamic> values,
  ) {
    final parts = <String>[];
    final year = values['year'];
    final make = values['make'];
    final model = values['model'];
    final type = values['asset_type'];

    if (year != null) parts.add(year.toString());
    if (make != null && make.toString().isNotEmpty) parts.add(make.toString());
    if (model != null && model.toString().isNotEmpty) {
      parts.add(model.toString());
    } else if (type != null && type.toString().isNotEmpty) {
      parts.add(type.toString());
    }

    return parts.isEmpty ? category.label : parts.join(' ');
  }

  /// Returns per-field validation error messages.
  Map<String, String> _validate(
    List<AssetFieldSchema> fields,
    Map<String, dynamic> values,
  ) {
    final errors = <String, String>{};
    for (final field in fields) {
      if (field.type == AssetFieldType.gpsCapture) continue;
      if (!field.isRequired) continue;

      final raw = values[field.key];
      final isEmpty =
          raw == null || raw.toString().trim().isEmpty;

      if (isEmpty) {
        errors[field.key] = '${field.label} is required';
        continue;
      }

      if (field.type == AssetFieldType.number ||
          field.type == AssetFieldType.year ||
          field.type == AssetFieldType.currency) {
        final numeric = double.tryParse(raw.toString());
        if (numeric == null) {
          errors[field.key] = 'Enter a valid number';
        } else {
          if (field.minValue != null && numeric < field.minValue!) {
            errors[field.key] =
                'Minimum value is ${field.minValue!.toInt()}';
          } else if (field.maxValue != null && numeric > field.maxValue!) {
            errors[field.key] =
                'Maximum value is ${field.maxValue!.toInt()}';
          }
        }
      }

      if (field.type == AssetFieldType.text ||
          field.type == AssetFieldType.vinScanner) {
        if (field.maxLength != null &&
            raw.toString().length > field.maxLength!) {
          errors[field.key] =
              'Maximum ${field.maxLength} characters';
        }
      }
    }
    return errors;
  }
}
