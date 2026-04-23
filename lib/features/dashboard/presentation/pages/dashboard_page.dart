import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/sync/sync_engine.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/dashboard/domain/entities/submission_summary.dart';
import 'package:pickles_direct/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:pickles_direct/features/dashboard/presentation/widgets/empty_dashboard.dart';
import 'package:pickles_direct/features/dashboard/presentation/widgets/submission_card.dart';
import 'package:pickles_direct/features/dashboard/presentation/widgets/sync_status_banner.dart';

/// Dashboard — the home screen for returning authenticated vendors.
///
/// Displays:
///   - Sync status banner (visible only when [SyncStatus.syncing] or [SyncStatus.failed])
///   - "Drafts" section for locally-saved submissions not yet uploaded
///   - "Submitted" section for server-confirmed assets
///   - Empty state when the vendor has no activity
///
/// FAB navigates to the item-quantity routing screen to start a new submission.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DashboardBloc>()..add(const DashboardStarted()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Submissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () => context.push(Routes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () => context.push(Routes.help),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.itemQuantityRouting),
        icon: const Icon(Icons.add),
        label: const Text('New Submission'),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) => switch (state) {
          DashboardInitial() || DashboardLoading() => const _LoadingBody(),
          DashboardError(:final message) => _ErrorBody(
              message: message,
              onRetry: () =>
                  context.read<DashboardBloc>().add(const DashboardStarted()),
            ),
          DashboardLoaded() => _LoadedBody(state: state),
        },
      ),
    );
  }
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Center(
      child: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimensions.iconSizeLg,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colours.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loaded ────────────────────────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final DashboardLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.isEmpty) {
      return EmptyDashboard(
        onNewSubmission: () => context.push(Routes.itemQuantityRouting),
      );
    }

    return Column(
      children: [
        // ── Sync banner ──────────────────────────────────────────────────
        SyncStatusBanner(
          syncStatus: state.syncStatus,
          onRetry: () =>
              context.read<DashboardBloc>().add(const DashboardSyncRequested()),
        ),

        // ── Submission list ──────────────────────────────────────────────
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async =>
                context.read<DashboardBloc>().add(const DashboardSyncRequested()),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (state.drafts.isNotEmpty) ...[
                  _SectionHeader(title: 'Drafts (${state.drafts.length})'),
                  _SubmissionSliver(
                    items: state.drafts,
                    onTap: (item) => _onDraftTapped(context, item),
                  ),
                ],
                if (state.submitted.isNotEmpty) ...[
                  _SectionHeader(title: 'Submitted (${state.submitted.length})'),
                  _SubmissionSliver(
                    items: state.submitted,
                    onTap: (item) => _onSubmittedTapped(context, item),
                  ),
                ],
                // Bottom padding so FAB does not obscure last card.
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.spacingXxl + AppDimensions.spacingXl),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onDraftTapped(BuildContext context, SubmissionSummary item) {
    // Navigate to Asset Form to resume editing the draft.
    // categoryKey is stored as assetCategory; draftId resumes the saved form.
    context.push(
      '${Routes.assetForm}/${item.assetCategory}?draftId=${item.id}',
    );
  }

  void _onSubmittedTapped(BuildContext context, SubmissionSummary item) {
    context.push('${Routes.submissionDetail}/${item.id}');
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.spacingMd,
          AppDimensions.spacingLg,
          AppDimensions.spacingMd,
          AppDimensions.spacingSm,
        ),
        child: Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: colours.onSurface,
          ),
        ),
      ),
    );
  }
}

// ── Submission Sliver ─────────────────────────────────────────────────────────

class _SubmissionSliver extends StatelessWidget {
  const _SubmissionSliver({required this.items, required this.onTap});

  final List<SubmissionSummary> items;
  final void Function(SubmissionSummary) onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
      sliver: SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.spacingSm),
        itemBuilder: (_, index) => SubmissionCard(
          submission: items[index],
          onTap: () => onTap(items[index]),
        ),
      ),
    );
  }
}
