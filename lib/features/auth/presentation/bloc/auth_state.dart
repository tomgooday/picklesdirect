part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});
  final User user;
  @override
  List<Object?> get props => [user];
}

/// Emitted on a fresh interactive sign-in (not a session restore).
/// The router uses this to direct new sessions to the routing screen (v1.4).
final class AuthNewSession extends AuthState {
  const AuthNewSession({required this.user});
  final User user;
  @override
  List<Object?> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthTermsRequired extends AuthState {
  const AuthTermsRequired({required this.user});
  final User user;
  @override
  List<Object?> get props => [user];
}

final class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

/// Shown when a suspended account attempts to sign in (BR-22).
final class AccountSuspendedFailure extends AuthState {
  const AccountSuspendedFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

final class AuthFailureState extends AuthState {
  const AuthFailureState({required this.failure});
  final Failure failure;
  @override
  List<Object?> get props => [failure];
}
