import 'package:flutter/material.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// Pickles Direct logo lockup — wordmark + tagline.
///
/// Uses a text-based implementation until the SVG logo asset is supplied by
/// the Pickles UX team. Drop `assets/images/pickles_direct_logo.svg` into
/// the assets folder and swap this widget for an SvgPicture.
class PicklesLogo extends StatelessWidget {
  const PicklesLogo({super.key, this.size = LogoSize.medium});

  final LogoSize size;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    final wordmarkStyle = switch (size) {
      LogoSize.small => AppTextStyles.titleLarge,
      LogoSize.medium => AppTextStyles.headlineMedium,
      LogoSize.large => AppTextStyles.displayLarge.copyWith(fontSize: 40),
    };

    final taglineStyle = switch (size) {
      LogoSize.small => AppTextStyles.labelSmall,
      LogoSize.medium => AppTextStyles.labelMedium,
      LogoSize.large => AppTextStyles.labelLarge,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Wordmark ───────────────────────────────────────────────────────
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Pickles ',
                style: wordmarkStyle.copyWith(
                  color: colours.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Direct',
                style: wordmarkStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // ── Tagline ────────────────────────────────────────────────────────
        Text(
          'Upload. Offload.',
          style: taglineStyle.copyWith(
            color: colours.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

enum LogoSize { small, medium, large }
