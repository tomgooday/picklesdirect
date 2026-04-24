import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_draft.dart';
import 'package:pickles_direct/features/asset_capture/domain/repositories/asset_draft_repository.dart';

@injectable
class LoadAssetDraft {
  const LoadAssetDraft(this._repository);

  final AssetDraftRepository _repository;

  Future<Either<Failure, AssetDraft?>> call(String draftId) =>
      _repository.loadDraft(draftId);
}
