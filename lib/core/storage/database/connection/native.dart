import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';

/// Opens a SQLite database backed by the device file system (Android / iOS /
/// desktop). Runs the actual database work on a background isolate so the UI
/// thread is never blocked.
QueryExecutor openAppDatabase() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
