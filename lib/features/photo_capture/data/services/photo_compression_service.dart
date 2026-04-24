import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';

abstract interface class PhotoCompressionService {
  /// Compresses source to JPEG and writes it to outputPath.
  /// Returns the compressed file, or the original if compression fails.
  Future<File> compress(String sourcePath, String outputPath);
}

@LazySingleton(as: PhotoCompressionService)
class PhotoCompressionServiceImpl implements PhotoCompressionService {
  @override
  Future<File> compress(String sourcePath, String outputPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      outputPath,
      quality: AppConstants.photoJpegQuality,
      minWidth: AppConstants.photoMinWidthPx,
      minHeight: AppConstants.photoMinHeightPx,
    );

    if (result == null) {
      // Compression failed — fall back to copying the original.
      final original = File(sourcePath);
      await original.copy(outputPath);
      return File(outputPath);
    }

    return File(result.path);
  }
}
