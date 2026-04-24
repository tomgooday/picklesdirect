import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';
import 'package:pickles_direct/features/photo_capture/domain/repositories/photo_repository.dart';

@injectable
class ListPhotos {
  const ListPhotos(this._repository);

  final PhotoRepository _repository;

  Future<Either<Failure, List<SubmissionPhoto>>> call(String draftId) =>
      _repository.listPhotos(draftId);
}
