import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickles_direct/core/config/feature_flags.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/features/photo_capture/domain/entities/photo_category.dart';
import 'package:pickles_direct/features/photo_capture/presentation/bloc/photo_capture_bloc.dart';
import 'package:pickles_direct/features/photo_capture/presentation/widgets/photo_category_sheet.dart';
import 'package:pickles_direct/features/photo_capture/presentation/widgets/photo_thumbnail_grid.dart';

class PhotoCapturePage extends StatelessWidget {
  const PhotoCapturePage({required this.draftId, super.key});
  final String draftId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<PhotoCaptureBloc>()..add(PhotoCaptureStarted(draftId)),
      child: _PhotoCaptureView(draftId: draftId),
    );
  }
}

class _PhotoCaptureView extends StatelessWidget {
  const _PhotoCaptureView({required this.draftId});
  final String draftId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhotoCaptureBloc, PhotoCaptureState>(
      listenWhen: (prev, curr) =>
          prev.pendingFile != curr.pendingFile ||
          prev.submitStatus != curr.submitStatus ||
          prev.failure != curr.failure,
      listener: (context, state) {
        if (state.pendingFile != null) {
          _showCategorySheet(context, state);
        }
        if (state.submitStatus == PhotoSubmitStatus.success) {
          context.go('${Routes.submissionConfirmation}/$draftId');
        }
        if (state.failure != null &&
            state.status != PhotoCaptureStatus.loading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure!.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: _AppBarTitle(
              count: state.photoCount,
              max: AppConstants.photoMaxCount,
            ),
          ),
          body: _Body(state: state),
          bottomNavigationBar: _BottomBar(state: state),
        );
      },
    );
  }

  Future<void> _showCategorySheet(
    BuildContext context,
    PhotoCaptureState state,
  ) async {
    final file = state.pendingFile;
    if (file == null) return;

    final category = await PhotoCategorySheet.show(
      context: context,
      coveredKeys: state.coveredRequiredKeys,
    );

    if (!context.mounted) return;

    if (category == null) {
      context.read<PhotoCaptureBloc>().add(
        const PhotoCaptureCategoryDismissed(),
      );
    } else {
      context.read<PhotoCaptureBloc>().add(
        PhotoCaptureCategorySelected(category: category, file: file),
      );
    }
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.count, required this.max});
  final int count;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Photos'),
        Text(
          '$count / $max',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});
  final PhotoCaptureState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == PhotoCaptureStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ProgressHeader(state: state)),
        SliverToBoxAdapter(
          child: state.isSaving
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Compressing photo…'),
                      ],
                    ),
                  ),
                )
              : PhotoThumbnailGrid(
                  photos: state.photos,
                  onDelete: (photo) => context.read<PhotoCaptureBloc>().add(
                    PhotoCaptureDeleted(photo),
                  ),
                  onReorder: (old_, new_) =>
                      context.read<PhotoCaptureBloc>().add(
                        PhotoCaptureReordered(oldIndex: old_, newIndex: new_),
                      ),
                ),
        ),
        if (state.missingRequiredKeys.isNotEmpty)
          SliverToBoxAdapter(
            child: _MissingCategoryHint(missing: state.missingRequiredKeys),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.state});
  final PhotoCaptureState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = (state.photoCount / AppConstants.photoMinCount).clamp(
      0.0,
      1.0,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  state.hasMinPhotos
                      ? 'Minimum photos captured'
                      : '${AppConstants.photoMinCount - state.photoCount} more photo'
                            '${AppConstants.photoMinCount - state.photoCount == 1 ? '' : 's'} required',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: state.hasMinPhotos
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${state.photoCount} / ${AppConstants.photoMinCount} required',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                state.hasMinPhotos ? colorScheme.primary : colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingCategoryHint extends StatelessWidget {
  const _MissingCategoryHint({required this.missing});
  final List<String> missing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labels = missing
        .map((k) => PhotoCategories.forKey(k)?.label ?? k)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.errorContainer),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 16, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Required shots still needed: ${labels.join(', ')}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state});
  final PhotoCaptureState state;

  @override
  Widget build(BuildContext context) {
    final flags = GetIt.instance<FeatureFlags>();
    final galleryEnabled = flags.isEnabled(AppConstants.flagPhotoGalleryImport);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (galleryEnabled)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isAtMaxPhotos || state.isSaving
                          ? null
                          : () => _pickFromGallery(context),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Gallery'),
                    ),
                  ),
                if (galleryEnabled) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: state.isAtMaxPhotos || state.isSaving
                        ? null
                        : () => _openCamera(context),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: state.hasMinPhotos && !state.isSaving
                    ? () => context.read<PhotoCaptureBloc>().add(
                        const PhotoCaptureSubmitRequested(),
                      )
                    : null,
                child: Text(
                  state.hasMinPhotos
                      ? 'Continue (${state.photoCount} photos)'
                      : 'Add ${AppConstants.photoMinCount - state.photoCount} more to continue',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100, // We compress ourselves.
    );
    if (file == null || !context.mounted) return;
    context.read<PhotoCaptureBloc>().add(PhotoCaptureImageCaptured(file));
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 100);
    if (files.isEmpty || !context.mounted) return;
    context.read<PhotoCaptureBloc>().add(PhotoCaptureGalleryPicked(files));
  }
}
