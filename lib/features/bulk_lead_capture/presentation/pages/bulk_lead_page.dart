import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/bloc/bulk_lead_bloc.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/widgets/asset_type_selector.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/widgets/vendor_contact_fields.dart';

/// Bulk Lead Capture form (BR-07A–BR-07F, SOW v1.4).
///
/// Lightweight form for vendors with 2+ items. Captures:
///   - Vendor name, phone, email
///   - Asset types (multi-select) with Make, Model, and Quantity per type
class BulkLeadPage extends StatelessWidget {
  const BulkLeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BulkLeadBloc>(),
      child: const _BulkLeadView(),
    );
  }
}

class _BulkLeadView extends StatelessWidget {
  const _BulkLeadView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BulkLeadBloc, BulkLeadState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.isSuccess) {
          context.go(Routes.bulkLeadConfirmation);
        }
        if (state.status == BulkLeadFormStatus.failure &&
            state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure!.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tell us about your items'),
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: const _BulkLeadForm(),
      ),
    );
  }
}

class _BulkLeadForm extends StatelessWidget {
  const _BulkLeadForm();

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return SingleChildScrollView(
      padding: AppDimensions.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Intro copy ─────────────────────────────────────────────────
          Text(
            'Give us the basics and a Pickles specialist will be in touch '
            'within one business day.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colours.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // ── Vendor contact fields ───────────────────────────────────────
          const VendorContactFields(),

          const SizedBox(height: AppDimensions.spacingLg),

          // ── Asset type multi-select ─────────────────────────────────────
          Text(
            'What types of items do you have?',
            style: AppTextStyles.titleMedium.copyWith(color: colours.onSurface),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            'Select all that apply. You can specify makes, models, and '
            'quantities for each.',
            style: AppTextStyles.bodySmall.copyWith(
              color: colours.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          const AssetTypeSelector(),

          const SizedBox(height: AppDimensions.spacingXl),

          // ── Submit button ───────────────────────────────────────────────
          BlocBuilder<BulkLeadBloc, BulkLeadState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.isSubmitting
                    ? null
                    : () => context.read<BulkLeadBloc>().add(
                        const BulkLeadSubmitRequested(),
                      ),
                child: state.isSubmitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Enquiry'),
              );
            },
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // ── Privacy note ────────────────────────────────────────────────
          Text(
            "By submitting, you agree to Pickles' Privacy Policy and "
            'Terms & Conditions.',
            style: AppTextStyles.bodySmall.copyWith(
              color: colours.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacingLg),
        ],
      ),
    );
  }
}
