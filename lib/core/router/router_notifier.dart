import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/router/routes.dart';

/// Listens to auth state changes and drives GoRouter redirects.
///
/// Post-login flow (SOW v1.4):
///   unknown            → /          (splash — resolve auth)
///   unauthenticated    → /login
///   onboarding         → /onboarding (first-run tutorial)
///   needsRouting       → /routing   (Step 1a: "How many items?")
///   authenticated      → /dashboard (returning users, or after routing)
@singleton
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._authStateStream) {
    _sub = _authStateStream.stream.listen((state) {
      _authState = state;
      notifyListeners();
    });
  }

  final AuthStateStream _authStateStream;
  StreamSubscription<AuthState>? _sub;
  AuthState _authState = AuthState.unknown;

  /// Called by GoRouter on every navigation event.
  String? redirect(BuildContext context, GoRouterState routerState) {
    final location = routerState.matchedLocation;

    final isPublicRoute = location == Routes.login ||
        location == Routes.register ||
        location == Routes.onboarding ||
        location == Routes.forgotPassword ||
        location == Routes.termsAcceptance;

    final isRoutingScreen = location == Routes.itemQuantityRouting;

    return switch (_authState) {
      AuthState.unknown => location == Routes.splash ? null : Routes.splash,
      AuthState.unauthenticated when !isPublicRoute => Routes.login,
      AuthState.onboarding when location != Routes.onboarding =>
        Routes.onboarding,
      // Newly authenticated users always hit the routing screen first (v1.4).
      AuthState.needsRouting when !isRoutingScreen =>
        Routes.itemQuantityRouting,
      // Returning authenticated users go straight to dashboard.
      AuthState.authenticated when isPublicRoute || isRoutingScreen =>
        Routes.dashboard,
      _ => null,
    };
  }

  @override
  Future<void> dispose() async {
    await _sub?.cancel();
    super.dispose();
  }
}

/// Auth states that drive routing decisions.
enum AuthState {
  /// App is starting — auth status not yet resolved.
  unknown,

  /// No valid session.
  unauthenticated,

  /// First-run: user authenticated but onboarding not complete.
  onboarding,

  /// Authenticated but not yet routed (new session — show Step 1a).
  needsRouting,

  /// Fully authenticated returning user.
  authenticated,
}

/// Thin stream abstraction — implemented by AuthBloc in the auth feature.
/// Keeps RouterNotifier decoupled from the auth Bloc directly.
abstract interface class AuthStateStream {
  Stream<AuthState> get stream;
}
