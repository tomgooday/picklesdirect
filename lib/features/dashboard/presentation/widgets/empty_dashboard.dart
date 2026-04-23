import 'package:flutter/material.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// Shown on the dashboard when the vendor has no drafts or submitted assets.
class EmptyDashboard extends StatelessWidget {
  const EmptyDashboard({required this.onNewSubmission, super.key});

  final VoidCallback onNewSubmission;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colours.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.upload_file_outlined,
                size: 48,
                color: colours.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            Text(
              'No submissions yet',
              style: AppTextStyles.headlineMedium.copyWith(
                color: colours.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spacingSm),

            Text(
              'Start by uploading your first asset for auction. '
              'A Pickles specialist will review it within one business day.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colours.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            ElevatedButton.icon(
              onPressed: onNewSubmission,
              icon: const Icon(Icons.add),
              label: const Text('New Submission'),
            ),
          ],
        ),
      ),
    );
  }
}
