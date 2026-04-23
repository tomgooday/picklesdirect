import 'package:flutter/material.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/dashboard/domain/entities/submission_summary.dart';

/// Displays a single submission in the dashboard list.
///
/// Tapping navigates the caller to the appropriate detail screen:
///   - Draft → Asset Form (resume editing)
///   - Submitted → Submission Detail
class SubmissionCard extends StatelessWidget {
  const SubmissionCard({
    required this.submission,
    required this.onTap,
    super.key,
  });

  final SubmissionSummary submission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Category icon ──────────────────────────────────────────
              _CategoryIcon(
                category: submission.assetCategory,
                colours: colours,
              ),
              const SizedBox(width: AppDimensions.spacingMd),

              // ── Content ────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            submission.assetLabel,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: colours.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        _StatusChip(
                          status: submission.status,
                          colours: colours,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.spacingXs),

                    // ── Meta row ─────────────────────────────────────────
                    Row(
                      children: [
                        Text(
                          _formatCategory(submission.assetCategory),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colours.onSurfaceVariant,
                          ),
                        ),
                        if (submission.photoCount != null &&
                            submission.photoCount! > 0) ...[
                          const SizedBox(width: AppDimensions.spacingSm),
                          Icon(
                            Icons.photo_library_outlined,
                            size: AppDimensions.iconSizeSm,
                            color: colours.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${submission.photoCount}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colours.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          _formatDate(submission.updatedAt),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colours.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    // ── Sync error message ────────────────────────────────
                    if (submission.status == SubmissionStatus.syncFailed &&
                        submission.lastSyncError != null) ...[
                      const SizedBox(height: AppDimensions.spacingXs),
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: AppDimensions.iconSizeSm,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              submission.lastSyncError!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: AppDimensions.spacingSm),
              Icon(
                Icons.chevron_right,
                size: AppDimensions.iconSizeMd,
                color: colours.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCategory(String categoryKey) {
    return categoryKey
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

// ── Category Icon ─────────────────────────────────────────────────────────────

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.category,
    required this.colours,
  });

  final String category;
  final ColourTokens colours;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colours.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Icon(
        _iconForCategory(category),
        size: AppDimensions.iconSizeMd,
        color: colours.onSurfaceVariant,
      ),
    );
  }

  IconData _iconForCategory(String key) => switch (key.toLowerCase()) {
        'vehicles' || 'vehicle' => Icons.directions_car_outlined,
        'trucks' || 'truck' => Icons.local_shipping_outlined,
        'trailers' || 'trailer' => Icons.rv_hookup_outlined,
        'industrial' || 'machinery' => Icons.precision_manufacturing_outlined,
        'earthmoving' => Icons.construction_outlined,
        'agricultural' || 'farm' => Icons.agriculture_outlined,
        'marine' || 'boats' => Icons.directions_boat_outlined,
        _ => Icons.inventory_2_outlined,
      };
}

// ── Status Chip ───────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.colours,
  });

  final SubmissionStatus status;
  final ColourTokens colours;

  @override
  Widget build(BuildContext context) {
    final (chipColour, textColour) = _colours(status, colours);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: chipColour.withAlpha(26),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: chipColour.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == SubmissionStatus.syncing) ...[
            SizedBox.square(
              dimension: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(textColour),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayLabel,
            style: AppTextStyles.labelSmall.copyWith(color: textColour),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colours(SubmissionStatus status, ColourTokens colours) =>
      switch (status) {
        SubmissionStatus.draft => (colours.statusDraft, colours.statusDraft),
        SubmissionStatus.queued => (colours.statusQueued, colours.statusQueued),
        SubmissionStatus.syncing => (
          colours.statusSyncing,
          colours.statusSyncing
        ),
        SubmissionStatus.syncFailed => (
          colours.scheme.error,
          colours.scheme.error
        ),
        SubmissionStatus.submitted => (
          colours.statusSubmitted,
          colours.statusSubmitted
        ),
        SubmissionStatus.valuationPending => (
          colours.statusValuationPending,
          colours.statusValuationPending
        ),
        SubmissionStatus.accepted => (
          colours.statusAccepted,
          colours.statusAccepted
        ),
        SubmissionStatus.listed => (colours.statusListed, colours.statusListed),
      };
}
