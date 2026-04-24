import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/asset_capture/presentation/bloc/asset_capture_bloc.dart';
import 'package:pickles_direct/features/asset_capture/presentation/widgets/schema_field_widget.dart';

/// Long Form — single-asset submission (1-item path).
///
/// Wired to [AssetCaptureBloc] via [BlocProvider]. On first mount the bloc
/// dispatches [AssetCaptureStarted] which loads the schema and optionally
/// restores an existing [draftId].
class AssetFormPage extends StatelessWidget {
  const AssetFormPage({
    required this.categoryKey,
    super.key,
    this.draftId,
  });

  final String categoryKey;
  final String? draftId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AssetCaptureBloc>()
        ..add(
          AssetCaptureStarted(categoryKey: categoryKey, draftId: draftId),
        ),
      child: _AssetFormView(categoryKey: categoryKey),
    );
  }
}

class _AssetFormView extends StatelessWidget {
  const _AssetFormView({required this.categoryKey});

  final String categoryKey;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Auto-save when the user navigates back.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          context
              .read<AssetCaptureBloc>()
              .add(const AssetDraftSaveRequested());
        }
      },
      child: BlocConsumer<AssetCaptureBloc, AssetCaptureState>(
        listenWhen: (prev, curr) =>
            prev.submitStatus != curr.submitStatus ||
            prev.saveStatus != curr.saveStatus,
        listener: (context, state) {
          if (state.submitStatus == FormSubmitStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Draft saved — queued for upload'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Navigate to photos screen.
            if (state.draftId != null) {
              context.push('${Routes.photoCapture}/${state.draftId}');
            }
          }

          if (state.submitStatus == FormSubmitStatus.error ||
              state.saveStatus == DraftSaveStatus.error) {
            final msg = state.failure?.message ?? 'Could not save draft';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.category?.label ?? 'New Asset'),
              leading: BackButton(onPressed: () => context.pop()),
              actions: [_SaveIndicator(saveStatus: state.saveStatus)],
            ),
            body: switch (state.status) {
              AssetCaptureStatus.loading ||
              AssetCaptureStatus.initial =>
                const Center(child: CircularProgressIndicator()),
              AssetCaptureStatus.error => _ErrorBody(
                  message: state.failure?.message ?? 'Something went wrong',
                ),
              AssetCaptureStatus.loaded => _FormBody(categoryKey: categoryKey),
            },
          );
        },
      ),
    );
  }
}

// ── Form body ─────────────────────────────────────────────────────────────────

class _FormBody extends StatelessWidget {
  const _FormBody({required this.categoryKey});

  final String categoryKey;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return BlocBuilder<AssetCaptureBloc, AssetCaptureState>(
      buildWhen: (prev, curr) => prev.category != curr.category,
      builder: (context, state) {
        final category = state.category;
        if (category == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Section intro ─────────────────────────────────────
              Text(
                'Fill in the details below. Required fields are marked — '
                'you can save a draft at any time.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colours.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // ── Schema-driven fields ──────────────────────────────
              ...category.fields.map(
                (field) => SchemaFieldWidget(key: ValueKey(field.key), schema: field),
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              // ── Validation summary ────────────────────────────────
              BlocBuilder<AssetCaptureBloc, AssetCaptureState>(
                buildWhen: (prev, curr) =>
                    prev.validationErrors != curr.validationErrors,
                builder: (context, state) {
                  if (state.validationErrors.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spacingMd,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingMd),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.errorContainer.withAlpha(80),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSm,
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error.withAlpha(100),
                        ),
                      ),
                      child: Text(
                        'Please fix ${state.validationErrors.length} '
                        'field${state.validationErrors.length == 1 ? '' : 's'} '
                        'before continuing.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── Save draft ────────────────────────────────────────
              OutlinedButton(
                onPressed: () => context
                    .read<AssetCaptureBloc>()
                    .add(const AssetDraftSaveRequested()),
                child: const Text('Save Draft'),
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              // ── Continue to photos ────────────────────────────────
              BlocBuilder<AssetCaptureBloc, AssetCaptureState>(
                buildWhen: (prev, curr) =>
                    prev.submitStatus != curr.submitStatus,
                builder: (context, state) {
                  final isSubmitting =
                      state.submitStatus == FormSubmitStatus.submitting;
                  return ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => context
                            .read<AssetCaptureBloc>()
                            .add(const AssetFormSubmitRequested()),
                    child: isSubmitting
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue to Photos'),
                  );
                },
              ),

              const SizedBox(height: AppDimensions.spacingXl),
            ],
          ),
        );
      },
    );
  }
}

// ── Save indicator chip in AppBar ─────────────────────────────────────────────

class _SaveIndicator extends StatelessWidget {
  const _SaveIndicator({required this.saveStatus});

  final DraftSaveStatus saveStatus;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    if (saveStatus == DraftSaveStatus.idle) return const SizedBox.shrink();

    final (label, color) = switch (saveStatus) {
      DraftSaveStatus.saving => ('Saving…', colours.onSurfaceVariant),
      DraftSaveStatus.saved => ('Saved', colours.statusSubmitted),
      DraftSaveStatus.error => ('Save failed', colours.scheme.error),
      DraftSaveStatus.idle => ('', colours.onSurfaceVariant),
    };

    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.spacingMd),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: color),
        ),
      ),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Center(
      child: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colours.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colours.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
