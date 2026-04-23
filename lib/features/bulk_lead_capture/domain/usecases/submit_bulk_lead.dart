import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/entities/bulk_lead.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/repositories/bulk_lead_repository.dart';

@injectable
class SubmitBulkLead {
  const SubmitBulkLead(this._repository);

  final BulkLeadRepository _repository;

  Future<Either<Failure, String>> call(BulkLead lead) {
    if (!lead.isReadyToSubmit) {
      return Future.value(
        const Left(
          ValidationFailure(
            message: 'Please complete all required fields before submitting.',
          ),
        ),
      );
    }
    return _repository.submitBulkLead(lead);
  }
}
