import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/photo_category.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';
import 'package:pickles_direct/features/photo_capture/domain/repositories/photo_repository.dart';
import 'package:pickles_direct/features/photo_capture/domain/usecases/add_photo.dart';
import 'package:pickles_direct/features/photo_capture/domain/usecases/delete_photo.dart';
import 'package:pickles_direct/features/photo_capture/domain/usecases/list_photos.dart';

part 'photo_capture_event.dart';
part 'photo_capture_state.dart';

@injectable
class PhotoCaptureBloc extends Bloc<PhotoCaptureEvent, PhotoCaptureState> {
  PhotoCaptureBloc(
    this._addPhoto,
    this._listPhotos,
    this._deletePhoto,
    this._photoRepository,
    this._log,
  ) : super(PhotoCaptureState.initial('')) {
    on<PhotoCaptureStarted>(_onStarted);
    on<PhotoCaptureImageCaptured>(_onImageCaptured);
    on<PhotoCaptureGalleryPicked>(_onGalleryPicked);
    on<PhotoCaptureCategorySelected>(_onCategorySelected);
    on<PhotoCaptureCategoryDismissed>(_onCategoryDismissed);
    on<PhotoCaptureDeleted>(_onDeleted);
    on<PhotoCaptureReordered>(_onReordered);
    on<PhotoCaptureSubmitRequested>(_onSubmitRequested);
  }

  final AddPhoto _addPhoto;
  final ListPhotos _listPhotos;
  final DeletePhoto _deletePhoto;
  final PhotoRepository _photoRepository;
  final Logger _log;

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onStarted(
    PhotoCaptureStarted event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    emit(
      PhotoCaptureState(
        status: PhotoCaptureStatus.loading,
        draftId: event.draftId,
      ),
    );

    final result = await _listPhotos(event.draftId);
    result.fold(
      (failure) => emit(
        PhotoCaptureState(
          status: PhotoCaptureStatus.error,
          draftId: event.draftId,
          failure: failure,
        ),
      ),
      (photos) => emit(
        PhotoCaptureState(
          status: PhotoCaptureStatus.ready,
          draftId: event.draftId,
          photos: photos,
        ),
      ),
    );
  }

  void _onImageCaptured(
    PhotoCaptureImageCaptured event,
    Emitter<PhotoCaptureState> emit,
  ) {
    // Store the pending file — the UI will open the category sheet.
    emit(state.copyWith(pendingFile: event.pendingFile));
  }

  void _onGalleryPicked(
    PhotoCaptureGalleryPicked event,
    Emitter<PhotoCaptureState> emit,
  ) {
    if (event.files.isEmpty) return;
    // Queue the first file; the rest are handled after assignment.
    emit(state.copyWith(pendingFile: event.files.first));
  }

  Future<void> _onCategorySelected(
    PhotoCaptureCategorySelected event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PhotoCaptureStatus.savingPhoto,
        clearPending: true,
      ),
    );

    final result = await _addPhoto(
      source: event.file,
      draftId: state.draftId,
      category: event.category,
      currentCount: state.photoCount,
    );

    result.fold(
      (failure) {
        _log.w('addPhoto failed: ${failure.message}');
        emit(
          state.copyWith(status: PhotoCaptureStatus.ready, failure: failure),
        );
      },
      (photo) => emit(
        state.copyWith(
          status: PhotoCaptureStatus.ready,
          photos: [...state.photos, photo],
          clearFailure: true,
        ),
      ),
    );
  }

  void _onCategoryDismissed(
    PhotoCaptureCategoryDismissed event,
    Emitter<PhotoCaptureState> emit,
  ) {
    emit(state.copyWith(clearPending: true));
  }

  Future<void> _onDeleted(
    PhotoCaptureDeleted event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    final result = await _deletePhoto(event.photo);
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) => emit(
        state.copyWith(
          photos: state.photos.where((p) => p.id != event.photo.id).toList(),
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> _onReordered(
    PhotoCaptureReordered event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    final reordered = List<SubmissionPhoto>.from(state.photos);
    final item = reordered.removeAt(event.oldIndex);
    reordered.insert(event.newIndex, item);

    // Optimistically update UI, then persist.
    emit(state.copyWith(photos: reordered));
    await _photoRepository.reorderPhotos(reordered);
  }

  void _onSubmitRequested(
    PhotoCaptureSubmitRequested event,
    Emitter<PhotoCaptureState> emit,
  ) {
    if (!state.hasMinPhotos) {
      emit(
        state.copyWith(
          failure: const PhotoValidationFailure(
            message:
                'Please add at least ${AppConstants.photoMinCount} photos '
                'before continuing.',
          ),
        ),
      );
      return;
    }
    emit(state.copyWith(submitStatus: PhotoSubmitStatus.success));
  }
}
