import 'package:flutter/material.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// "Sign in with Microsoft" button — Microsoft brand compliant styling.
/// Disabled until Azure Entra client ID is configured.
class MicrosoftSignInButton extends StatelessWidget {
  const MicrosoftSignInButton({
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
        backgroundColor: colours.surface,
        side: BorderSide(color: colours.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
      ),
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Microsoft 4-colour logo squares
                _MicrosoftLogo(),
                const SizedBox(width: AppDimensions.spacingMd),
                Text(
                  'Sign in with Microsoft',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colours.onSurface,
                  ),
                ),
              ],
            ),
    );
  }
}

class _MicrosoftLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 20,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.zero,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ColoredBox(color: Color(0xFFF25022)), // red
          ColoredBox(color: Color(0xFF7FBA00)), // green
          ColoredBox(color: Color(0xFF00A4EF)), // blue
          ColoredBox(color: Color(0xFFFFB900)), // yellow
        ],
      ),
    );
  }
}
