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
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase is provisioned by Pickles Platform Ops (see EXTERNAL_DEPENDENCIES.md).
  // Until real credentials are supplied the placeholder API keys will cause
  // initializeApp to throw — we catch that and run without Firebase so the
  // PWA is still usable during development.
  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } on Exception catch (e) {
    // ignore: avoid_print
    print('[main] Firebase init skipped (placeholder credentials?): $e');
  }

  if (firebaseReady) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  await runZonedGuarded(
    () async {
      await configureDependencies();

      // Start background sync engine.
      await getIt<SyncEngine>().start();

      runApp(const PicklesDirectApp());
    },
    (error, stack) {
      if (firebaseReady) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } else {
        // ignore: avoid_print
        print('[main] Uncaught error (no Crashlytics): $error\n$stack');
      }
    },
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
