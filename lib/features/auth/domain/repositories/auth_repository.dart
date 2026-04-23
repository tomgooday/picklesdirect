import 'package:dartz/dartz.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  /// Returns the currently cached user, or null if not authenticated.
  Future<User?> getCurrentUser();

  /// Email + password sign-in.
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Microsoft Entra External ID (Azure B2C) interactive sign-in.
  Future<Either<Failure, User>> signInWithMsal();

  /// Creates a new vendor account.
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sends a password-reset email.
  Future<Either<Failure, Unit>> sendPasswordReset({required String email});

  /// Signs the user out and clears local tokens.
  Future<Either<Failure, Unit>> signOut();

  /// Records that the user accepted the current T&C version.
  Future<Either<Failure, Unit>> acceptTerms({required String version});

  /// Records that the user accepted the current Privacy Policy version.
  Future<Either<Failure, Unit>> acceptPrivacyPolicy({required String version});

  Stream<User?> get authStateChanges;
}
