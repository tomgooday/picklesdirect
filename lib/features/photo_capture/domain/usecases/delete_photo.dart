import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';
import 'package:pickles_direct/features/photo_capture/domain/repositories/photo_repository.dart';

@injectable
class DeletePhoto {
  const DeletePhoto(this._repository);

  final PhotoRepository _repository;

  Future<Either<Failure, Unit>> call(SubmissionPhoto photo) =>
      _repository.deletePhoto(photo);
}
