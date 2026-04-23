import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/auth/domain/entities/user.dart';
import 'package:pickles_direct/features/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthMsalSignInRequested>(_onMsalSignInRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthTermsAccepted>(_onTermsAccepted);

    // Subscribe to real-time auth state changes (token expiry, remote sign-out).
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user == null) {
        add(const AuthSignOutRequested());
      }
    });
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      emit(const AuthUnauthenticated());
    } else if (!user.hasAcceptedCurrentTc) {
      emit(AuthTermsRequired(user: user));
    } else {
      emit(AuthAuthenticated(user: user));
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.signInWithEmailPassword(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure: failure)),
      (user) => emit(
        user.hasAcceptedCurrentTc
            ? AuthNewSession(user: user)
            : AuthTermsRequired(user: user),
      ),
    );
  }

  Future<void> _onMsalSignInRequested(
    AuthMsalSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.signInWithMsal();
    result.fold(
      (failure) => emit(AuthFailureState(failure: failure)),
      (user) => emit(
        user.hasAcceptedCurrentTc
            ? AuthNewSession(user: user)
            : AuthTermsRequired(user: user),
      ),
    );
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result =
        await _authRepository.sendPasswordReset(email: event.email);
    result.fold(
      (failure) => emit(AuthFailureState(failure: failure)),
      (_) => emit(const AuthPasswordResetSent()),
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.register(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure: failure)),
      (user) => emit(AuthTermsRequired(user: user)),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onTermsAccepted(
    AuthTermsAccepted event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.acceptTerms(version: event.version);
    result.fold(
      (failure) => emit(AuthFailureState(failure: failure)),
      (_) {
        final currentState = state;
        if (currentState is AuthTermsRequired) {
          // First sign-in: after accepting T&C, send to routing screen.
          emit(AuthNewSession(user: currentState.user));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
