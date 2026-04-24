import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/photo_category.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';

abstract interface class PhotoRepository {
  /// Compresses source, persists to device storage and the Drift table,
  /// then increments the photoCount on the parent draft.
  Future<Either<Failure, SubmissionPhoto>> addPhoto({
    required XFile source,
    required String draftId,
    required PhotoCategory category,
    required int sortOrder,
  });

  /// Returns all photos for a given draftId ordered by sortOrder.
  Future<Either<Failure, List<SubmissionPhoto>>> listPhotos(String draftId);

  /// Deletes the Drift row, the local file, and decrements the draft photoCount.
  Future<Either<Failure, Unit>> deletePhoto(SubmissionPhoto photo);

  /// Persists updated sort order after a drag-reorder.
  Future<Either<Failure, Unit>> reorderPhotos(List<SubmissionPhoto> reordered);

  /// Removes all photos and their files for a draft (called on draft delete).
  Future<Either<Failure, Unit>> deleteAllForDraft(String draftId);

  /// Returns the compressed file for a photo (for upload by SyncService).
  File fileFor(SubmissionPhoto photo);
}
