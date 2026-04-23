import 'package:flutter/material.dart';
import 'package:pickles_direct/core/sync/sync_engine.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// An animated banner shown at the top of the dashboard when the sync engine
/// is actively uploading or has encountered a failure.
///
/// Hidden entirely when [syncStatus] is [SyncStatus.idle] or [SyncStatus.completed].
/// Tapping the failure state dispatches the provided [onRetry] callback.
class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({
    required this.syncStatus,
    required this.onRetry,
    super.key,
  });

  final SyncStatus syncStatus;
  final VoidCallback onRetry;

  bool get _isVisible =>
      syncStatus == SyncStatus.syncing || syncStatus == SyncStatus.failed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: _isVisible
          ? _BannerContent(syncStatus: syncStatus, onRetry: onRetry)
          : const SizedBox.shrink(),
    );
  }
}

class _BannerContent extends StatelessWidget {
  const _BannerContent({required this.syncStatus, required this.onRetry});

  final SyncStatus syncStatus;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isFailed = syncStatus == SyncStatus.failed;
    final backgroundColour = isFailed
        ? Theme.of(context).colorScheme.errorContainer
        : const Color(0xFFE3F2FD);
    final foregroundColour = isFailed
        ? Theme.of(context).colorScheme.onErrorContainer
        : const Color(0xFF0277BD);

    return GestureDetector(
      onTap: isFailed ? onRetry : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
          vertical: AppDimensions.spacingSm,
        ),
        color: backgroundColour,
        child: Row(
          children: [
            if (isFailed)
              Icon(
                Icons.sync_problem,
                size: AppDimensions.iconSizeSm,
                color: foregroundColour,
              )
            else
              SizedBox.square(
                dimension: AppDimensions.iconSizeSm,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColour),
                ),
              ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                isFailed
                    ? 'Sync failed. Tap to retry.'
                    : 'Syncing submissions…',
                style: AppTextStyles.bodySmall.copyWith(
                  color: foregroundColour,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isFailed)
              Icon(
                Icons.chevron_right,
                size: AppDimensions.iconSizeSm,
                color: foregroundColour,
              ),
          ],
        ),
      ),
    );
  }
}
