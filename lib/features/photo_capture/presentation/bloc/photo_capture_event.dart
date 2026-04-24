part of 'photo_capture_bloc.dart';

sealed class PhotoCaptureEvent extends Equatable {
  const PhotoCaptureEvent();
  @override
  List<Object?> get props => [];
}

/// Load existing photos for [draftId] on page mount.
final class PhotoCaptureStarted extends PhotoCaptureEvent {
  const PhotoCaptureStarted(this.draftId);
  final String draftId;

  @override
  List<Object?> get props => [draftId];
}

/// User opened the camera and captured an image.
/// pendingFile is the raw XFile awaiting category assignment.
final class PhotoCaptureImageCaptured extends PhotoCaptureEvent {
  const PhotoCaptureImageCaptured(this.pendingFile);
  final XFile pendingFile;

  @override
  List<Object?> get props => [pendingFile.path];
}

/// User picked one or more images from the gallery.
final class PhotoCaptureGalleryPicked extends PhotoCaptureEvent {
  const PhotoCaptureGalleryPicked(this.files);
  final List<XFile> files;

  @override
  List<Object?> get props => [files.map((f) => f.path).toList()];
}

/// User selected a category for the pending file in the bottom sheet.
final class PhotoCaptureCategorySelected extends PhotoCaptureEvent {
  const PhotoCaptureCategorySelected({
    required this.category,
    required this.file,
  });
  final PhotoCategory category;
  final XFile file;

  @override
  List<Object?> get props => [category.key, file.path];
}

/// User dismissed the category sheet without selecting — discard pending image.
final class PhotoCaptureCategoryDismissed extends PhotoCaptureEvent {
  const PhotoCaptureCategoryDismissed();
}

/// User tapped the delete icon on a thumbnail.
final class PhotoCaptureDeleted extends PhotoCaptureEvent {
  const PhotoCaptureDeleted(this.photo);
  final SubmissionPhoto photo;

  @override
  List<Object?> get props => [photo.id];
}

/// User dragged a photo to a new position.
final class PhotoCaptureReordered extends PhotoCaptureEvent {
  const PhotoCaptureReordered({required this.oldIndex, required this.newIndex});
  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

/// User tapped "Continue" — validate count and route to confirmation.
final class PhotoCaptureSubmitRequested extends PhotoCaptureEvent {
  const PhotoCaptureSubmitRequested();
}
