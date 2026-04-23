import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pickles_direct/features/auth/domain/entities/user.dart';
import 'package:pickles_direct/features/auth/domain/repositories/auth_repository.dart';
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late AuthBloc bloc;

  setUp(() {
    mockRepo = MockAuthRepository();
    when(
      () => mockRepo.authStateChanges,
    ).thenAnswer((_) => const Stream.empty());
    bloc = AuthBloc(mockRepo);
  });

  tearDown(() => bloc.close());

  group('AuthBloc', () {
    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when no user is cached',
        build: () {
          when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
          return bloc;
        },
        act: (b) => b.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when active user is cached',
        build: () {
          when(
            () => mockRepo.getCurrentUser(),
          ).thenAnswer((_) async => _testUser);
          return bloc;
        },
        act: (b) => b.add(const AuthCheckRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(user: _testUser),
        ],
      );
    });

    group('AuthSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthNewSession] on successful interactive sign-in',
        build: () {
          when(
            () => mockRepo.signInWithEmailPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(_testUser));
          return bloc;
        },
        act: (b) => b.add(
          const AuthSignInRequested(
            email: 'david@test.com.au',
            password: 'Password1!',
          ),
        ),
        // Fresh interactive sign-in emits AuthNewSession so the router
        // can direct the user to the Step 1a routing screen (SOW v1.4).
        expect: () => [
          const AuthLoading(),
          const AuthNewSession(user: _testUser),
        ],
      );
    });
  });
}

// ── Fixtures ──────────────────────────────────────────────────────────────────

const _testUser = User(
  id: 'usr_001',
  email: 'david@test.com.au',
  displayName: 'David Harper',
  status: UserStatus.active,
  tcVersionAccepted: '1.0',
  privacyVersionAccepted: '1.0',
);
