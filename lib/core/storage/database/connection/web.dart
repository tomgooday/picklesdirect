// ignore_for_file: deprecated_member_use
// drift/web.dart (IndexedDB) is in bugfix-only mode. Migrate to
// drift/wasm.dart once the WASM service worker assets are set up.
import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';

/// Opens a Drift database backed by IndexedDB for the web / PWA target.
/// Data is persisted across page reloads via the browser's IndexedDB API.
QueryExecutor openAppDatabase() {
  return WebDatabase(AppConstants.databaseName);
}
