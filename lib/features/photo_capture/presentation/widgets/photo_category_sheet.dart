import 'package:flutter/material.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/photo_category.dart';

/// Bottom sheet that lets the user assign a shot category to a pending photo.
///
/// Returns the selected [PhotoCategory] or null if dismissed.
class PhotoCategorySheet extends StatelessWidget {
  const PhotoCategorySheet({required this.coveredKeys, super.key});

  /// Category keys that already have at least one photo — used to surface
  /// a "covered" indicator so the user knows which categories are filled.
  final Set<String> coveredKeys;

  static Future<PhotoCategory?> show({
    required BuildContext context,
    required Set<String> coveredKeys,
  }) => showModalBottomSheet<PhotoCategory>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => PhotoCategorySheet(coveredKeys: coveredKeys),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const required = PhotoCategories.required;
    final optional = PhotoCategories.all.where((c) => !c.isRequired).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'What is this photo of?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const _SectionHeader(label: 'Required shots'),
                ...required.map(
                  (cat) => _CategoryTile(
                    category: cat,
                    isCovered: coveredKeys.contains(cat.key),
                  ),
                ),
                const SizedBox(height: 8),
                const _SectionHeader(label: 'Optional shots'),
                ...optional.map(
                  (cat) => _CategoryTile(
                    category: cat,
                    isCovered: coveredKeys.contains(cat.key),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.isCovered});
  final PhotoCategory category;
  final bool isCovered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCovered
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        child: Icon(
          isCovered ? Icons.check : category.icon,
          size: 20,
          color: isCovered
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
      title: Row(
        children: [
          Text(category.label),
          if (category.isRequired && !isCovered) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Required',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(category.description, style: theme.textTheme.bodySmall),
      onTap: () => Navigator.of(context).pop(category),
    );
  }
}
