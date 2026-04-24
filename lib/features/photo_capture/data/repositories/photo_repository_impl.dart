import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/core/storage/database/app_database.dart' as db;
import 'package:pickles_direct/features/photo_capture/data/services/photo_compression_service.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/photo_category.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';
import 'package:pickles_direct/features/photo_capture/domain/repositories/photo_repository.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: PhotoRepository)
class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl(this._db, this._compression, this._log);

  final db.AppDatabase _db;
  final PhotoCompressionService _compression;
  final Logger _log;

  @override
  Future<Either<Failure, SubmissionPhoto>> addPhoto({
    required XFile source,
    required String draftId,
    required PhotoCategory category,
    required int sortOrder,
  }) async {
    try {
      final photoId = const Uuid().v4();
      final outputPath = await _buildOutputPath(draftId, photoId);

      final compressed = await _compression.compress(source.path, outputPath);
      final fileSize = await compressed.length();
      final dimensions = await _readDimensions(compressed);

      final now = DateTime.now();
      await _db
          .into(_db.submissionPhotos)
          .insert(
            db.SubmissionPhotosCompanion(
              id: Value(photoId),
              submissionId: Value(draftId),
              categoryKey: Value(category.key),
              originalFilename: Value(p.basename(source.path)),
              localPath: Value(compressed.path),
              fileSizeBytes: Value(fileSize),
              widthPx: Value(dimensions.$1),
              heightPx: Value(dimensions.$2),
              sortOrder: Value(sortOrder),
              capturedAt: Value(now),
            ),
          );

      // Increment draft photoCount.
      await (_db.update(
        _db.submissionDrafts,
      )..where((t) => t.id.equals(draftId))).write(
        db.SubmissionDraftsCompanion(
          photoCount: Value(sortOrder + 1),
          updatedAt: Value(now),
        ),
      );

      return Right(
        SubmissionPhoto(
          id: photoId,
          submissionId: draftId,
          categoryKey: category.key,
          categoryLabel: category.label,
          localPath: compressed.path,
          originalFilename: p.basename(source.path),
          fileSizeBytes: fileSize,
          widthPx: dimensions.$1,
          heightPx: dimensions.$2,
          sortOrder: sortOrder,
          capturedAt: now,
        ),
      );
    } on Exception catch (e) {
      _log.e('addPhoto failed', error: e);
      return Left(StorageFailure(message: 'Failed to save photo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SubmissionPhoto>>> listPhotos(
    String draftId,
  ) async {
    try {
      final rows =
          await (_db.select(_db.submissionPhotos)
                ..where((t) => t.submissionId.equals(draftId))
                ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
              .get();

      return Right(rows.map(_rowToPhoto).toList());
    } on Exception catch (e) {
      _log.e('listPhotos failed', error: e);
      return Left(StorageFailure(message: 'Failed to list photos: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePhoto(SubmissionPhoto photo) async {
    try {
      await (_db.delete(
        _db.submissionPhotos,
      )..where((t) => t.id.equals(photo.id))).go();

      // Decrement draft photoCount.
      final draft = await (_db.select(
        _db.submissionDrafts,
      )..where((t) => t.id.equals(photo.submissionId))).getSingleOrNull();
      if (draft != null && draft.photoCount > 0) {
        await (_db.update(
          _db.submissionDrafts,
        )..where((t) => t.id.equals(photo.submissionId))).write(
          db.SubmissionDraftsCompanion(
            photoCount: Value(draft.photoCount - 1),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // Delete file from storage.
      final file = File(photo.localPath);
      if (file.existsSync()) file.deleteSync();

      return const Right(unit);
    } on Exception catch (e) {
      _log.e('deletePhoto failed', error: e);
      return Left(StorageFailure(message: 'Failed to delete photo: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> reorderPhotos(
    List<SubmissionPhoto> reordered,
  ) async {
    try {
      for (var i = 0; i < reordered.length; i++) {
        await (_db.update(_db.submissionPhotos)
              ..where((t) => t.id.equals(reordered[i].id)))
            .write(db.SubmissionPhotosCompanion(sortOrder: Value(i)));
      }
      return const Right(unit);
    } on Exception catch (e) {
      _log.e('reorderPhotos failed', error: e);
      return Left(StorageFailure(message: 'Failed to reorder photos: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllForDraft(String draftId) async {
    try {
      final rows = await (_db.select(
        _db.submissionPhotos,
      )..where((t) => t.submissionId.equals(draftId))).get();

      for (final row in rows) {
        final file = File(row.localPath);
        if (file.existsSync()) file.deleteSync();
      }

      await (_db.delete(
        _db.submissionPhotos,
      )..where((t) => t.submissionId.equals(draftId))).go();

      return const Right(unit);
    } on Exception catch (e) {
      _log.e('deleteAllForDraft failed', error: e);
      return Left(StorageFailure(message: 'Failed to delete photos: $e'));
    }
  }

  @override
  File fileFor(SubmissionPhoto photo) => File(photo.localPath);

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<String> _buildOutputPath(String draftId, String photoId) async {
    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'photos', draftId));
    if (!photoDir.existsSync()) await photoDir.create(recursive: true);
    return p.join(photoDir.path, '$photoId.jpg');
  }

  /// Reads image dimensions using the `image` package on a background isolate.
  Future<(int, int)> _readDimensions(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final decoded = await compute((data) {
        final image = img.decodeImage(data);
        return image != null ? (image.width, image.height) : (0, 0);
      }, bytes);
      return decoded;
    } on Exception {
      return (0, 0);
    }
  }

  SubmissionPhoto _rowToPhoto(db.SubmissionPhoto row) => SubmissionPhoto(
    id: row.id,
    submissionId: row.submissionId,
    categoryKey: row.categoryKey,
    categoryLabel:
        PhotoCategories.forKey(row.categoryKey)?.label ?? row.categoryKey,
    localPath: row.localPath,
    originalFilename: row.originalFilename,
    fileSizeBytes: row.fileSizeBytes,
    widthPx: row.widthPx,
    heightPx: row.heightPx,
    sortOrder: row.sortOrder,
    capturedAt: row.capturedAt,
    gpsLat: row.gpsLat,
    gpsLng: row.gpsLng,
  );
}
