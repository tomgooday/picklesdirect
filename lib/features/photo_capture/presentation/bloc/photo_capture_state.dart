part of 'photo_capture_bloc.dart';

enum PhotoCaptureStatus { initial, loading, ready, savingPhoto, error }

enum PhotoSubmitStatus { idle, validating, success, error }

final class PhotoCaptureState extends Equatable {
  const PhotoCaptureState({
    required this.status,
    required this.draftId,
    this.photos = const [],
    this.pendingFile,
    this.submitStatus = PhotoSubmitStatus.idle,
    this.failure,
  });

  factory PhotoCaptureState.initial(String draftId) =>
      PhotoCaptureState(status: PhotoCaptureStatus.initial, draftId: draftId);

  final PhotoCaptureStatus status;
  final String draftId;

  /// Sorted list of photos already attached to this draft.
  final List<SubmissionPhoto> photos;

  /// A captured/picked image waiting for category assignment in the bottom sheet.
  final XFile? pendingFile;

  final PhotoSubmitStatus submitStatus;
  final Failure? failure;

  int get photoCount => photos.length;
  bool get hasMinPhotos => photoCount >= AppConstants.photoMinCount;
  bool get isAtMaxPhotos => photoCount >= AppConstants.photoMaxCount;
  bool get isSaving => status == PhotoCaptureStatus.savingPhoto;

  /// Keys of required categories that have at least one photo assigned.
  Set<String> get coveredRequiredKeys =>
      photos.map((p) => p.categoryKey).toSet();

  /// Which required category keys are still missing a photo.
  List<String> get missingRequiredKeys => PhotoCategories.required
      .map((c) => c.key)
      .where((k) => !coveredRequiredKeys.contains(k))
      .toList();

  PhotoCaptureState copyWith({
    PhotoCaptureStatus? status,
    List<SubmissionPhoto>? photos,
    XFile? pendingFile,
    bool clearPending = false,
    PhotoSubmitStatus? submitStatus,
    Failure? failure,
    bool clearFailure = false,
  }) => PhotoCaptureState(
    status: status ?? this.status,
    draftId: draftId,
    photos: photos ?? this.photos,
    pendingFile: clearPending ? null : pendingFile ?? this.pendingFile,
    submitStatus: submitStatus ?? this.submitStatus,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    draftId,
    photos,
    pendingFile?.path,
    submitStatus,
    failure,
  ];
}
