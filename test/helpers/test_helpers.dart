/// Shared test helpers, factories, and bloc test utilities.
library;

import 'package:mocktail/mocktail.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/auth/domain/entities/user.dart';
import 'package:pickles_direct/features/auth/domain/repositories/auth_repository.dart';
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';

// ── Mock declarations ─────────────────────────────────────────────────────────

class MockAuthRepository extends Mock implements AuthRepository {}

// ── Test fixtures ─────────────────────────────────────────────────────────────

const kTestUser = User(
  id: 'usr_test_001',
  email: 'david.harper@testfleet.com.au',
  displayName: 'David Harper',
  status: UserStatus.active,
  businessName: 'Harper Fleet Management',
  abn: '12345678901',
  tcVersionAccepted: '1.0',
  privacyVersionAccepted: '1.0',
);

const kTestUserNoTc = User(
  id: 'usr_test_002',
  email: 'sarah.mitchell@testfarm.com.au',
  displayName: 'Sarah Mitchell',
  status: UserStatus.active,
);

const kTestNetworkFailure = NetworkFailure();
const kTestServerFailure = ServerFailure(message: 'Internal server error.', statusCode: 500);
const kTestAuthFailure = AuthFailure(message: 'Invalid credentials.', code: 'invalid_credentials');

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Registers fallback values for mocktail.
/// Call once from setUpAll in any test file using mocks.
void registerFallbackValues() {
  registerFallbackValue(const AuthCheckRequested());
}
