import 'package:flutter/material.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_category.dart';

/// Tappable card shown in the AssetCategoryPage grid.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.onTap,
    super.key,
  });

  final AssetCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: colours.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: colours.outline),
          ),
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  category.icon,
                  color: primary,
                  size: AppDimensions.iconSizeMd,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                category.label,
                style: AppTextStyles.titleMedium.copyWith(
                  color: colours.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                category.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colours.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
