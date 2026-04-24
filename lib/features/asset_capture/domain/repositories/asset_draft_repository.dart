import 'package:dartz/dartz.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_draft.dart';

abstract interface class AssetDraftRepository {
  /// Creates or replaces a draft in local storage.
  Future<Either<Failure, Unit>> saveDraft(AssetDraft draft);

  /// Loads a single draft by [draftId], or null if not found.
  Future<Either<Failure, AssetDraft?>> loadDraft(String draftId);

  /// Returns all drafts for the current vendor, newest first.
  Future<Either<Failure, List<AssetDraft>>> listDrafts(String vendorId);

  /// Removes a draft and its associated photos.
  Future<Either<Failure, Unit>> deleteDraft(String draftId);
}
