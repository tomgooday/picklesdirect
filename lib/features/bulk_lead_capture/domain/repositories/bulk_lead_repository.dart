import 'package:dartz/dartz.dart';
import 'package:pickles_direct/core/error/failures.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/entities/bulk_lead.dart';

abstract interface class BulkLeadRepository {
  /// Submits the bulk lead to AutoCheck via Pickles middleware.
  /// Returns the remote lead ID on success.
  Future<Either<Failure, String>> submitBulkLead(BulkLead lead);
}
