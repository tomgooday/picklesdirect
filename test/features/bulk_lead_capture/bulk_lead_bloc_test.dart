import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/entities/bulk_lead.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/usecases/submit_bulk_lead.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/bloc/bulk_lead_bloc.dart';

class MockSubmitBulkLead extends Mock implements SubmitBulkLead {}

void main() {
  late MockSubmitBulkLead mockSubmit;
  late BulkLeadBloc bloc;

  setUpAll(() {
    registerFallbackValue(_validLead);
  });

  setUp(() {
    mockSubmit = MockSubmitBulkLead();
    bloc = BulkLeadBloc(mockSubmit);
  });

  tearDown(() => bloc.close());

  group('BulkLeadBloc', () {
    group('BulkLeadVendorDetailsChanged', () {
      blocTest<BulkLeadBloc, BulkLeadState>(
        'updates vendor name in lead',
        build: () => bloc,
        act: (b) => b.add(
          const BulkLeadVendorDetailsChanged(vendorName: 'David Harper'),
        ),
        verify: (b) {
          expect(b.state.lead.vendorName, 'David Harper');
        },
      );
    });

    group('BulkLeadAssetTypeToggled', () {
      blocTest<BulkLeadBloc, BulkLeadState>(
        'adds asset item when type selected',
        build: () => bloc,
        act: (b) => b.add(
          const BulkLeadAssetTypeToggled(
            assetTypeKey: 'excavators',
            assetTypeLabel: 'Excavators',
          ),
        ),
        verify: (b) {
          expect(b.state.isAssetTypeSelected('excavators'), isTrue);
          expect(b.state.lead.assetItems, hasLength(1));
          expect(b.state.lead.assetItems.first.quantity, 1);
        },
      );

      blocTest<BulkLeadBloc, BulkLeadState>(
        'removes asset item when type deselected',
        build: () => bloc,
        act: (b) => b
          ..add(const BulkLeadAssetTypeToggled(
            assetTypeKey: 'excavators',
            assetTypeLabel: 'Excavators',
          ))
          ..add(const BulkLeadAssetTypeToggled(
            assetTypeKey: 'excavators',
            assetTypeLabel: 'Excavators',
          )),
        verify: (b) {
          expect(b.state.isAssetTypeSelected('excavators'), isFalse);
          expect(b.state.lead.assetItems, isEmpty);
        },
      );
    });

    group('BulkLeadSubmitRequested', () {
      blocTest<BulkLeadBloc, BulkLeadState>(
        'emits submitting then success on valid lead',
        build: () {
          when(() => mockSubmit(any())).thenAnswer(
            (_) async => const Right('remote-lead-id-001'),
          );
          return bloc;
        },
        seed: () => const BulkLeadState(
          lead: _validLead,
          status: BulkLeadFormStatus.initial,
        ),
        act: (b) => b.add(const BulkLeadSubmitRequested()),
        expect: () => [
          isA<BulkLeadState>().having(
            (s) => s.status,
            'status',
            BulkLeadFormStatus.submitting,
          ),
          isA<BulkLeadState>().having(
            (s) => s.status,
            'status',
            BulkLeadFormStatus.success,
          ),
        ],
      );

      blocTest<BulkLeadBloc, BulkLeadState>(
        'emits failure when submission returns an error',
        build: () {
          when(() => mockSubmit(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Service unavailable.', statusCode: 503),
            ),
          );
          return bloc;
        },
        seed: () => const BulkLeadState(
          lead: _validLead,
          status: BulkLeadFormStatus.initial,
        ),
        act: (b) => b.add(const BulkLeadSubmitRequested()),
        expect: () => [
          isA<BulkLeadState>()
              .having((s) => s.status, 'status', BulkLeadFormStatus.submitting),
          isA<BulkLeadState>()
              .having((s) => s.status, 'status', BulkLeadFormStatus.failure),
        ],
      );
    });
  });
}

// ── Fixtures ──────────────────────────────────────────────────────────────────

const _validLead = BulkLead(
  id: 'test-lead-001',
  vendorName: 'David Harper',
  phone: '0412345678',
  email: 'david@harper.com.au',
  assetItems: [
    BulkLeadAssetItem(
      assetTypeKey: 'excavators',
      assetTypeLabel: 'Excavators',
      quantity: 2,
      make: 'Caterpillar',
    ),
  ],
);
