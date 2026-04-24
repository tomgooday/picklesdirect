import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/photo_category.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';
import 'package:pickles_direct/features/photo_capture/domain/repositories/photo_repository.dart';

@injectable
class AddPhoto {
  const AddPhoto(this._repository);

  final PhotoRepository _repository;

  Future<Either<Failure, SubmissionPhoto>> call({
    required XFile source,
    required String draftId,
    required PhotoCategory category,
    required int currentCount,
  }) async {
    if (currentCount >= AppConstants.photoMaxCount) {
      return const Left(
        PhotoValidationFailure(
          message:
              'Maximum of ${AppConstants.photoMaxCount} photos allowed per submission.',
        ),
      );
    }

    final fileSizeBytes = await source.length();
    if (fileSizeBytes > AppConstants.photoMaxSizeBytes) {
      return const Left(
        PhotoValidationFailure(
          message:
              'Photo is too large (max ${AppConstants.photoMaxSizeBytes ~/ (1024 * 1024)} MB). '
              'Please try again.',
        ),
      );
    }

    return _repository.addPhoto(
      source: source,
      draftId: draftId,
      category: category,
      sortOrder: currentCount,
    );
  }
}
