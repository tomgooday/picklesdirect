// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import '../../features/asset_capture/data/repositories/asset_draft_repository_impl.dart'
    as _i363;
import '../../features/asset_capture/domain/repositories/asset_draft_repository.dart'
    as _i899;
import '../../features/asset_capture/domain/usecases/load_asset_draft.dart'
    as _i268;
import '../../features/asset_capture/domain/usecases/save_asset_draft.dart'
    as _i812;
import '../../features/asset_capture/presentation/bloc/asset_capture_bloc.dart'
    as _i28;
import '../../features/auth/data/auth_state_stream_bridge.dart' as _i853;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/bulk_lead_capture/domain/repositories/bulk_lead_repository.dart'
    as _i427;
import '../../features/bulk_lead_capture/domain/usecases/submit_bulk_lead.dart'
    as _i991;
import '../../features/bulk_lead_capture/presentation/bloc/bulk_lead_bloc.dart'
    as _i465;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/watch_dashboard_items.dart'
    as _i46;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../config/app_config.dart' as _i650;
import '../config/feature_flags.dart' as _i645;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/interceptors/retry_interceptor.dart' as _i914;
import '../network/network_info.dart' as _i932;
import '../router/router_notifier.dart' as _i36;
import '../security/encryption_service.dart' as _i320;
import '../security/token_storage.dart' as _i77;
import '../storage/database/app_database.dart' as _i406;
import '../sync/sync_engine.dart' as _i846;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i77.TokenStorage>(
      () => _i77.TokenStorageImpl(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i77.AuthRefreshService>(),
      ),
    );
    gh.factory<_i914.RetryInterceptor>(
      () => _i914.RetryInterceptor(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i320.EncryptionService>(
      () => _i320.EncryptionServiceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i645.FeatureFlags>(
      () => _i645.FeatureFlagsImpl(gh<_i645.FlagsRepository>()),
    );
    gh.lazySingleton<_i665.DashboardRepository>(
      () => _i509.DashboardRepositoryImpl(gh<_i406.AppDatabase>()),
    );
    gh.factory<_i991.SubmitBulkLead>(
      () => _i991.SubmitBulkLead(gh<_i427.BulkLeadRepository>()),
    );
    gh.lazySingleton<_i899.AssetDraftRepository>(
      () => _i363.AssetDraftRepositoryImpl(
        gh<_i406.AppDatabase>(),
        gh<_i320.EncryptionService>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i846.SyncEngine>(
      () => _i846.SyncEngineImpl(
        gh<_i932.NetworkInfo>(),
        gh<_i846.SubmissionSyncService>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i46.WatchDashboardItems>(
      () => _i46.WatchDashboardItems(gh<_i665.DashboardRepository>()),
    );
    gh.factory<_i745.AuthInterceptor>(
      () => _i745.AuthInterceptor(gh<_i77.TokenStorage>()),
    );
    gh.singleton<_i36.AuthStateStream>(
      () => _i853.AuthStateStreamBridge(gh<_i797.AuthBloc>()),
    );
    gh.factory<_i268.LoadAssetDraft>(
      () => _i268.LoadAssetDraft(gh<_i899.AssetDraftRepository>()),
    );
    gh.factory<_i812.SaveAssetDraft>(
      () => _i812.SaveAssetDraft(gh<_i899.AssetDraftRepository>()),
    );
    gh.factory<_i28.AssetCaptureBloc>(
      () => _i28.AssetCaptureBloc(
        gh<_i812.SaveAssetDraft>(),
        gh<_i268.LoadAssetDraft>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i650.AppConfig>(),
        gh<_i745.AuthInterceptor>(),
        gh<_i914.RetryInterceptor>(),
      ),
    );
    gh.factory<_i465.BulkLeadBloc>(
      () => _i465.BulkLeadBloc(gh<_i991.SubmitBulkLead>()),
    );
    gh.singleton<_i36.RouterNotifier>(
      () => _i36.RouterNotifier(gh<_i36.AuthStateStream>()),
    );
    gh.factory<_i652.DashboardBloc>(
      () => _i652.DashboardBloc(
        gh<_i46.WatchDashboardItems>(),
        gh<_i846.SyncEngine>(),
      ),
    );
    return this;
  }
}
