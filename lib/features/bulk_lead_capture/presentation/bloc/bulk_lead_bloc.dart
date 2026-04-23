import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/entities/bulk_lead.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/usecases/submit_bulk_lead.dart';
import 'package:uuid/uuid.dart';

part 'bulk_lead_event.dart';
part 'bulk_lead_state.dart';

@injectable
class BulkLeadBloc extends Bloc<BulkLeadEvent, BulkLeadState> {
  BulkLeadBloc(this._submitBulkLead)
      : super(BulkLeadState.initial()) {
    on<BulkLeadVendorDetailsChanged>(_onVendorDetailsChanged);
    on<BulkLeadAssetTypeToggled>(_onAssetTypeToggled);
    on<BulkLeadAssetItemUpdated>(_onAssetItemUpdated);
    on<BulkLeadSubmitRequested>(_onSubmitRequested);
    on<BulkLeadReset>(_onReset);
  }

  final SubmitBulkLead _submitBulkLead;

  void _onVendorDetailsChanged(
    BulkLeadVendorDetailsChanged event,
    Emitter<BulkLeadState> emit,
  ) {
    emit(
      state.copyWith(
        lead: state.lead.copyWith(
          vendorName: event.vendorName ?? state.lead.vendorName,
          phone: event.phone ?? state.lead.phone,
          email: event.email ?? state.lead.email,
        ),
      ),
    );
  }

  void _onAssetTypeToggled(
    BulkLeadAssetTypeToggled event,
    Emitter<BulkLeadState> emit,
  ) {
    final items = List<BulkLeadAssetItem>.from(state.lead.assetItems);
    final existingIndex =
        items.indexWhere((i) => i.assetTypeKey == event.assetTypeKey);

    if (existingIndex >= 0) {
      // Deselect — remove the item (BR-07B: fields collapse on deselect).
      items.removeAt(existingIndex);
    } else {
      // Select — add with default quantity of 1.
      items.add(
        BulkLeadAssetItem(
          assetTypeKey: event.assetTypeKey,
          assetTypeLabel: event.assetTypeLabel,
          quantity: 1,
        ),
      );
    }

    emit(state.copyWith(lead: state.lead.copyWith(assetItems: items)));
  }

  void _onAssetItemUpdated(
    BulkLeadAssetItemUpdated event,
    Emitter<BulkLeadState> emit,
  ) {
    final items = List<BulkLeadAssetItem>.from(state.lead.assetItems);
    final index =
        items.indexWhere((i) => i.assetTypeKey == event.assetTypeKey);
    if (index < 0) return;

    items[index] = items[index].copyWith(
      quantity: event.quantity,
      make: event.make,
      model: event.model,
    );

    emit(state.copyWith(lead: state.lead.copyWith(assetItems: items)));
  }

  Future<void> _onSubmitRequested(
    BulkLeadSubmitRequested event,
    Emitter<BulkLeadState> emit,
  ) async {
    emit(state.copyWith(status: BulkLeadFormStatus.submitting));

    final result = await _submitBulkLead(state.lead);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BulkLeadFormStatus.failure,
          failure: failure,
        ),
      ),
      (remoteId) => emit(
        state.copyWith(
          status: BulkLeadFormStatus.success,
          submittedRemoteId: remoteId,
        ),
      ),
    );
  }

  void _onReset(BulkLeadReset event, Emitter<BulkLeadState> emit) {
    emit(BulkLeadState.initial());
  }
}
