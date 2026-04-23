import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/router/router_notifier.dart'
    as router
    show AuthState, AuthStateStream;
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';

/// Bridges `AuthBloc` sealed-class states → router `AuthStateStream` enum
/// values so that `RouterNotifier` stays decoupled from the Bloc layer.
@Singleton(as: router.AuthStateStream)
class AuthStateStreamBridge implements router.AuthStateStream {
  AuthStateStreamBridge(this._authBloc);

  final AuthBloc _authBloc;

  @override
  Stream<router.AuthState> get stream => _authBloc.stream.map(_toRouterState);

  router.AuthState _toRouterState(AuthState state) => switch (state) {
    AuthInitial() || AuthLoading() => router.AuthState.unknown,
    AuthAuthenticated() => router.AuthState.authenticated,
    // Fresh interactive sign-in → show routing screen (SOW v1.4 Step 1a).
    AuthNewSession() => router.AuthState.needsRouting,
    AuthUnauthenticated() => router.AuthState.unauthenticated,
    AccountSuspendedFailure() => router.AuthState.unauthenticated,
    // User must accept T&C — treated as a blocking onboarding step.
    AuthTermsRequired() => router.AuthState.onboarding,
    // Non-navigation states — keep router unchanged.
    AuthFailureState() || AuthPasswordResetSent() => router.AuthState.unknown,
  };
}
