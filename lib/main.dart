import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/router/app_router.dart';
import 'package:pickles_direct/core/sync/sync_engine.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/firebase_options.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Route all Flutter framework errors to Crashlytics.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      await configureDependencies();

      // Start background sync engine.
      await getIt<SyncEngine>().start();

      runApp(const PicklesDirectApp());
    },
    // Route all uncaught async errors to Crashlytics.
    (error, stack) => FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    ),
  );
}

class PicklesDirectApp extends StatelessWidget {
  const PicklesDirectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;

    return MaterialApp.router(
      title: 'Pickles Direct',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      builder: (context, child) => _AppWrapper(child: child),
    );
  }
}

/// Wraps the entire app to handle session timeout, connectivity banners,
/// and global overlays (offline indicator).
class _AppWrapper extends StatelessWidget {
  const _AppWrapper({this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // TODO(pickles): add offline connectivity banner and session timeout listener.
    return child ?? const SizedBox.shrink();
  }
}
