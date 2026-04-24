import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/asset_capture/data/datasources/asset_schema_service.dart';
import 'package:pickles_direct/features/asset_capture/presentation/widgets/category_card.dart';

/// Step 1 of the Long Form (1-item path).
///
/// Displays a 2-column grid of asset categories. Selecting one navigates to
/// AssetFormPage with the chosen category key as the path parameter.
class AssetCategoryPage extends StatelessWidget {
  const AssetCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;
    final categories = AssetSchemaService.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('What are you selling?'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: AppDimensions.screenPadding,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select the category that best matches your asset.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colours.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
            ),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimensions.spacingMd,
                crossAxisSpacing: AppDimensions.spacingMd,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  onTap: () => context.push(
                    '${Routes.assetForm}/${category.key}',
                  ),
                );
              },
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacingXl),
          ),
        ],
      ),
    );
  }
}
