import 'package:injectable/injectable.dart';
import 'package:pickles_direct/features/dashboard/domain/entities/submission_summary.dart';
import 'package:pickles_direct/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Returns a live stream of all submission summaries for the dashboard list.
@injectable
class WatchDashboardItems {
  const WatchDashboardItems(this._repository);

  final DashboardRepository _repository;

  Stream<List<SubmissionSummary>> call() => _repository.watchAllItems();
}
