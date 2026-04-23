// Platform-conditional Drift database connection.
//
// On web (dart.library.js_interop) the IndexedDB-backed WebDatabase is used.
// On every other target (Android, iOS, desktop, unit tests) the native SQLite
// NativeDatabase running in a background isolate is used.
export 'package:pickles_direct/core/storage/database/connection/native.dart'
    if (dart.library.js_interop) 'package:pickles_direct/core/storage/database/connection/web.dart';
