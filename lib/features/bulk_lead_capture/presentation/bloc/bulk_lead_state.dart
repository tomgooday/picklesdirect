part of 'bulk_lead_bloc.dart';

enum BulkLeadFormStatus { initial, submitting, success, failure }

final class BulkLeadState extends Equatable {
  const BulkLeadState({
    required this.lead,
    required this.status,
    this.failure,
    this.submittedRemoteId,
  });

  factory BulkLeadState.initial() => BulkLeadState(
        lead: BulkLead(
          id: const Uuid().v4(),
          vendorName: '',
          phone: '',
          email: '',
          assetItems: const [],
        ),
        status: BulkLeadFormStatus.initial,
      );

  final BulkLead lead;
  final BulkLeadFormStatus status;
  final Failure? failure;
  final String? submittedRemoteId;

  bool get isSubmitting => status == BulkLeadFormStatus.submitting;
  bool get isSuccess => status == BulkLeadFormStatus.success;

  bool isAssetTypeSelected(String key) =>
      lead.assetItems.any((i) => i.assetTypeKey == key);

  BulkLeadAssetItem? itemForType(String key) =>
      lead.assetItems.where((i) => i.assetTypeKey == key).firstOrNull;

  BulkLeadState copyWith({
    BulkLead? lead,
    BulkLeadFormStatus? status,
    Failure? failure,
    String? submittedRemoteId,
  }) =>
      BulkLeadState(
        lead: lead ?? this.lead,
        status: status ?? this.status,
        failure: failure ?? this.failure,
        submittedRemoteId: submittedRemoteId ?? this.submittedRemoteId,
      );

  @override
  List<Object?> get props => [lead, status, failure, submittedRemoteId];
}
