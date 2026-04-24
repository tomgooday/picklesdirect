import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/storage/database/app_database.dart' as db;
import 'package:pickles_direct/features/photo_capture/domain/entities/submission_photo.dart';
import 'package:pickles_direct/features/photo_capture/presentation/bloc/photo_capture_bloc.dart';

/// Shown after the user taps "Continue" with ≥ 8 photos.
///
/// Displays a summary of the draft and a thumbnail strip of the first
/// five photos. The user can return to add more photos or go to the
/// dashboard to track the submission.
class SubmissionConfirmationPage extends StatelessWidget {
  const SubmissionConfirmationPage({required this.draftId, super.key});
  final String draftId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<PhotoCaptureBloc>()..add(PhotoCaptureStarted(draftId)),
      child: _ConfirmationView(draftId: draftId),
    );
  }
}

class _ConfirmationView extends StatefulWidget {
  const _ConfirmationView({required this.draftId});
  final String draftId;

  @override
  State<_ConfirmationView> createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<_ConfirmationView> {
  db.SubmissionDraft? _draft;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final appDb = GetIt.instance<db.AppDatabase>();
    final draft = await (appDb.select(
      appDb.submissionDrafts,
    )..where((t) => t.id.equals(widget.draftId))).getSingleOrNull();
    if (mounted) setState(() => _draft = draft);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoCaptureBloc, PhotoCaptureState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Submission Ready'),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success icon
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 40,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Looking great!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Your submission is ready to sync.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Draft summary card
                  if (_draft != null) _DraftSummaryCard(draft: _draft!),

                  const SizedBox(height: 24),

                  // Photo strip
                  if (state.photos.isNotEmpty) ...[
                    Text(
                      'Photos (${state.photoCount})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _PhotoStrip(photos: state.photos),
                    const SizedBox(height: 24),
                  ],

                  // Sync info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your submission will sync automatically when '
                            "you're connected to Wi-Fi or mobile data.",
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // CTAs
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.go(Routes.dashboard),
                      icon: const Icon(Icons.dashboard_outlined),
                      label: const Text('Go to Dashboard'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(
                        '${Routes.photoCapture}/${widget.draftId}',
                      ),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: const Text('Add More Photos'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DraftSummaryCard extends StatelessWidget {
  const _DraftSummaryCard({required this.draft});
  final db.SubmissionDraft draft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              draft.assetLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              draft.assetCategory,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.photo_library_outlined,
              label:
                  '${draft.photoCount} photo${draft.photoCount == 1 ? '' : 's'} attached',
            ),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.schedule,
              label: 'Last updated ${_formatTime(draft.updatedAt)}',
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({required this.photos});
  final List<SubmissionPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final photo = photos[i];
          return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(
              File(photo.localPath),
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
