import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// Step 1a (SOW v1.4) — post-login routing decision.
///
/// Asks "How many items do you have to sell?" and routes to:
///   • 1 Item  → [Routes.assetCategory] (Long Form path)
///   • 2+ Items → [Routes.bulkLead] (Bulk Lead Capture path)
class ItemQuantityRoutingPage extends StatelessWidget {
  const ItemQuantityRoutingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colours = theme.brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        title: const Text('Pickles Direct'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacingXl),

              // ── Heading ──────────────────────────────────────────────────
              Text(
                'How many items do you have to sell?',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: colours.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              Text(
                "We'll tailor the experience to match your needs.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colours.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingXxl),

              // ── 1 Item card ───────────────────────────────────────────────
              _RoutingOptionCard(
                icon: Icons.directions_car_outlined,
                title: '1 Item',
                subtitle:
                    'Submit a single asset with full details, photos, and condition — '
                    'receive a valuation within 24 hours.',
                onTap: () => context.go(Routes.assetCategory),
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              // ── 2+ Items card ─────────────────────────────────────────────
              _RoutingOptionCard(
                icon: Icons.inventory_2_outlined,
                title: '2+ Items',
                subtitle:
                    'Tell us about your fleet or bulk lot — a Pickles specialist '
                    'will be in touch to manage your submission.',
                onTap: () => context.go(Routes.bulkLead),
              ),

              const Spacer(),

              // ── Help link ─────────────────────────────────────────────────
              TextButton.icon(
                onPressed: () => context.push(Routes.help),
                icon: const Icon(
                  Icons.help_outline,
                  size: AppDimensions.iconSizeSm,
                ),
                label: const Text('Need help? Contact Pickles'),
                style: TextButton.styleFrom(
                  foregroundColor: colours.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private components ────────────────────────────────────────────────────────

class _RoutingOptionCard extends StatelessWidget {
  const _RoutingOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colours = theme.brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Material(
      color: colours.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: colours.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: AppDimensions.iconSizeLg,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colours.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colours.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Icon(Icons.chevron_right, color: colours.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
