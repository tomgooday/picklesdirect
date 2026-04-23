import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pickles_direct/core/config/app_config.dart';
import 'package:pickles_direct/core/di/injection.config.dart';
import 'package:pickles_direct/core/router/app_router.dart';
import 'package:pickles_direct/core/router/router_notifier.dart'
    show AuthStateStream, RouterNotifier;
import 'package:pickles_direct/core/storage/database/app_database.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // Register third-party instances not handled by @injectable annotations.
  // AppRouter and RouterNotifier are wired manually because RouterNotifier
  // depends on AuthStateStream (an abstract interface satisfied by
  // AuthStateStreamBridge, which itself needs AuthBloc — registered above
  // by injectable). Manual wiring avoids the circular-ref issue with the
  // injectable generator.
  getIt
    ..registerSingleton<AppConfig>(AppConfig.fromEnvironment())
    ..registerLazySingleton<Logger>(() => Logger(printer: PrettyPrinter()))
    ..registerLazySingleton(Connectivity.new)
    ..registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new)
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..$initGetIt()
    ..registerSingleton<RouterNotifier>(
      RouterNotifier(getIt<AuthStateStream>()),
    )
    ..registerSingleton<AppRouter>(
      AppRouter(getIt<RouterNotifier>()),
    );
}
