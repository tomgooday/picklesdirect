import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// On-screen confirmation shown after a successful bulk lead submission (BR-07F).
///
/// Confirms the enquiry has been received and sets expectations:
/// "A Pickles representative will be in touch."
class BulkLeadConfirmationPage extends StatelessWidget {
  const BulkLeadConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colours =
        theme.brightness == Brightness.dark ? AppColours.dark : AppColours.light;

    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // ── Success icon ───────────────────────────────────────────
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 44,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // ── Heading ────────────────────────────────────────────────
              Text(
                'Enquiry received!',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: colours.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              // ── Body ────────────────────────────────────────────────────
              Text(
                'A Pickles specialist will review your enquiry and be in '
                'touch within one business day.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colours.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              Text(
                "We've also sent a confirmation to your email address.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colours.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // ── Actions ─────────────────────────────────────────────────
              ElevatedButton(
                onPressed: () => context.go(Routes.dashboard),
                child: const Text('Go to My Submissions'),
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              OutlinedButton(
                onPressed: () => context.go(Routes.itemQuantityRouting),
                child: const Text('Submit Another Item'),
              ),

              const SizedBox(height: AppDimensions.spacingLg),
            ],
          ),
        ),
      ),
    );
  }
}
