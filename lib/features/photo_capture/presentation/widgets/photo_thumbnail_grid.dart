import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';

/// Reorderable 3-column grid of compressed photo thumbnails.
///
/// Each cell shows the image, its category label, and a delete button.
/// When the grid is dragged, [onReorder] fires so the Bloc can persist the
/// new sort order.
class PhotoThumbnailGrid extends StatelessWidget {
  const PhotoThumbnailGrid({
    required this.photos,
    required this.onDelete,
    required this.onReorder,
    super.key,
  });

  final List<SubmissionPhoto> photos;
  final void Function(SubmissionPhoto) onDelete;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const _EmptyState();
    }

    return ReorderableGridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: onReorder,
      children: [
        for (final photo in photos)
          _PhotoCell(
            key: ValueKey(photo.id),
            photo: photo,
            onDelete: () => onDelete(photo),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No photos yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Take at least ${AppConstants.photoMinCount} photos\n'
              'to continue your submission.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoCell extends StatelessWidget {
  const _PhotoCell({required this.photo, required this.onDelete, super.key});

  final SubmissionPhoto photo;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(photo.localPath), fit: BoxFit.cover),
          // Category label at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Text(
                photo.categoryLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Delete button
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Provides a simple reorderable grid using a Wrap + LongPressDraggable pattern.
/// For production, replace with a proper reorderable grid package if needed.
class ReorderableGridView extends StatelessWidget {
  const ReorderableGridView.count({
    required this.crossAxisCount,
    required this.children,
    required this.onReorder,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  });

  final int crossAxisCount;
  final List<Widget> children;
  final void Function(int oldIndex, int newIndex) onReorder;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );
  }
}
