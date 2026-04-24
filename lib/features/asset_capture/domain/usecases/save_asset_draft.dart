import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_draft.dart';
import 'package:pickles_direct/features/asset_capture/domain/repositories/asset_draft_repository.dart';

@injectable
class SaveAssetDraft {
  const SaveAssetDraft(this._repository);

  final AssetDraftRepository _repository;

  Future<Either<Failure, Unit>> call(AssetDraft draft) async {
    final countResult = await _repository.listDrafts(draft.vendorId);
    return countResult.fold(
      Left.new,
      (drafts) async {
        final isNew = !drafts.any((d) => d.id == draft.id);
        if (isNew && drafts.length >= AppConstants.maxDraftSubmissions) {
          return const Left(DraftLimitExceededFailure());
        }
        return _repository.saveDraft(draft);
      },
    );
  }
}
