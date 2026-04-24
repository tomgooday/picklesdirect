import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/core/security/encryption_service.dart';
import 'package:pickles_direct/core/storage/database/app_database.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_draft.dart';
import 'package:pickles_direct/features/asset_capture/domain/repositories/asset_draft_repository.dart';

@LazySingleton(as: AssetDraftRepository)
class AssetDraftRepositoryImpl implements AssetDraftRepository {
  AssetDraftRepositoryImpl(this._db, this._encryption, this._log);

  final AppDatabase _db;
  final EncryptionService _encryption;
  final Logger _log;

  @override
  Future<Either<Failure, Unit>> saveDraft(AssetDraft draft) async {
    try {
      final payload = jsonEncode(draft.fieldValues);
      final encrypted = await _encryption.encrypt(payload);

      await _db
          .into(_db.submissionDrafts)
          .insertOnConflictUpdate(
            SubmissionDraftsCompanion(
              id: Value(draft.id),
              vendorId: Value(draft.vendorId),
              status: Value(draft.status.name),
              assetPayloadEncrypted: Value(encrypted),
              assetCategory: Value(draft.categoryKey),
              assetLabel: Value(draft.assetLabel),
              gpsLat: Value(draft.gpsLat),
              gpsLng: Value(draft.gpsLng),
              photoCount: Value(draft.photoCount),
              retryCount: const Value(0),
              createdAt: Value(draft.createdAt),
              updatedAt: Value(draft.updatedAt),
            ),
          );
      return const Right(unit);
    } on Exception catch (e) {
      _log.e('saveDraft failed', error: e);
      return Left(StorageFailure(message: 'Failed to save draft: $e'));
    }
  }

  @override
  Future<Either<Failure, AssetDraft?>> loadDraft(String draftId) async {
    try {
      final row = await (_db.select(
        _db.submissionDrafts,
      )..where((t) => t.id.equals(draftId))).getSingleOrNull();

      if (row == null) return const Right(null);
      return Right(await _rowToDraft(row));
    } on Exception catch (e) {
      _log.e('loadDraft failed', error: e);
      return Left(StorageFailure(message: 'Failed to load draft: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AssetDraft>>> listDrafts(String vendorId) async {
    try {
      final rows =
          await (_db.select(_db.submissionDrafts)
                ..where((t) => t.vendorId.equals(vendorId))
                ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
              .get();

      final drafts = await Future.wait(rows.map(_rowToDraft));
      return Right(drafts);
    } on Exception catch (e) {
      _log.e('listDrafts failed', error: e);
      return Left(StorageFailure(message: 'Failed to list drafts: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDraft(String draftId) async {
    try {
      await (_db.delete(
        _db.submissionDrafts,
      )..where((t) => t.id.equals(draftId))).go();
      return const Right(unit);
    } on Exception catch (e) {
      _log.e('deleteDraft failed', error: e);
      return Left(StorageFailure(message: 'Failed to delete draft: $e'));
    }
  }

  Future<AssetDraft> _rowToDraft(SubmissionDraft row) async {
    var values = <String, dynamic>{};
    try {
      final plaintext = await _encryption.decrypt(row.assetPayloadEncrypted);
      values = jsonDecode(plaintext) as Map<String, dynamic>;
    } on Exception catch (e) {
      _log.w('Could not decrypt draft ${row.id}', error: e);
    }

    return AssetDraft(
      id: row.id,
      vendorId: row.vendorId,
      categoryKey: row.assetCategory,
      assetLabel: row.assetLabel,
      fieldValues: values,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      gpsLat: row.gpsLat,
      gpsLng: row.gpsLng,
      photoCount: row.photoCount,
      status: DraftStatus.values.byName(row.status),
    );
  }
}
