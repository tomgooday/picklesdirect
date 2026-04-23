import 'package:flutter/material.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// Horizontal rule with centred label — "or continue with".
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, this.label = 'or continue with'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Row(
      children: [
        Expanded(child: Divider(color: colours.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
          ),
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: colours.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: colours.outline)),
      ],
    );
  }
}
