import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/pickles_logo.dart';

/// BRU-18: Users must read and explicitly accept the Terms & Conditions
/// before first use. This screen is shown after registration and whenever
/// the T&C version is updated.
class TermsAcceptancePage extends StatelessWidget {
  const TermsAcceptancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _TermsView(),
    );
  }
}

class _TermsView extends StatefulWidget {
  const _TermsView();

  @override
  State<_TermsView> createState() => _TermsViewState();
}

class _TermsViewState extends State<_TermsView> {
  bool _hasScrolledToBottom = false;
  bool _agreed = false;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      setState(() => _hasScrolledToBottom = true);
    }
  }

  void _accept(BuildContext context) {
    context.read<AuthBloc>().add(
          const AuthTermsAccepted(version: AppConstants.termsVersion),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/');
        }
        if (state is AuthFailureState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const PicklesLogo(size: LogoSize.small),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withAlpha(60),
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: colours.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version ${AppConstants.termsVersion} · Please read before continuing',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colours.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scroll hint ───────────────────────────────────────────────
            if (!_hasScrolledToBottom)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingXs,
                ),
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withAlpha(120),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      size: 14,
                      color: colours.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Scroll to the bottom to continue',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colours.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Body text ─────────────────────────────────────────────────
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildTermsSections(context, colours),
                  ),
                ),
              ),
            ),

            // ── Footer CTA ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              decoration: BoxDecoration(
                color: colours.surface,
                boxShadow: [
                  BoxShadow(
                    color: colours.onSurface.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: _hasScrolledToBottom
                              ? (v) => setState(() => _agreed = v ?? false)
                              : null,
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
                        Expanded(
                          child: Text(
                            'I have read and agree to the Pickles Direct Terms & Conditions',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: colours.onSurface),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.spacingMd),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final loading = state is AuthLoading;
                        return ElevatedButton(
                          onPressed:
                              (_agreed && !loading) ? () => _accept(context) : null,
                          child: loading
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Accept & Continue'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTermsSections(
    BuildContext context,
    ColourTokens colours,
  ) {
    const headingStyle = TextStyle(fontWeight: FontWeight.w600);

    return [
      Text(
        'These Terms and Conditions govern your use of the Pickles Direct mobile application and associated services provided by Pickles Auctions Pty Ltd (ABN 83 011 930 090) ("Pickles").',
        style: AppTextStyles.bodyMedium.copyWith(color: colours.onSurface),
      ),
      const SizedBox(height: AppDimensions.spacingLg),

      _termSection(
        context: context,
        colours: colours,
        heading: '1. Acceptance of Terms',
        headingStyle: headingStyle,
        body:
            'By registering an account or using the Pickles Direct application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, do not use the application.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '2. Eligibility',
        headingStyle: headingStyle,
        body:
            'You must be at least 18 years of age and hold a valid Australian Business Number (ABN) to use this service. You warrant that all information you provide is accurate, current, and complete.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '3. Vendor Obligations',
        headingStyle: headingStyle,
        body:
            'You represent and warrant that: (a) you own or have the legal right to sell any assets listed; (b) all descriptions, photographs, and information submitted accurately represent the condition of the asset; (c) assets are free of any encumbrances that would prevent sale, unless disclosed.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '4. Valuations',
        headingStyle: headingStyle,
        body:
            'Valuation estimates provided by Pickles are indicative only and do not constitute a guarantee of sale price. Final prices are determined by the auction process and buyer demand. Pickles reserves the right to decline any listing at its sole discretion.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '5. Fees and Payments',
        headingStyle: headingStyle,
        body:
            'Pickles charges a commission on successfully sold items as communicated in your vendor agreement. Commission rates, payment timelines, and any applicable GST obligations are outlined in the separate Vendor Fee Schedule.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '6. Photography and Data',
        headingStyle: headingStyle,
        body:
            'By submitting photographs and information via this application, you grant Pickles a non-exclusive, worldwide, royalty-free licence to use, reproduce, and display the submitted content for the purpose of marketing, conducting auctions, and operating its services.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '7. Privacy',
        headingStyle: headingStyle,
        body:
            'Pickles collects and processes your personal information in accordance with its Privacy Policy, available at pickles.com.au/privacy-policy. By using this application, you consent to such collection and processing.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '8. Limitation of Liability',
        headingStyle: headingStyle,
        body:
            'To the maximum extent permitted by law, Pickles shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of this application, including but not limited to loss of profits, data, or business opportunity.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '9. Governing Law',
        headingStyle: headingStyle,
        body:
            'These Terms are governed by the laws of New South Wales, Australia. Any disputes are subject to the exclusive jurisdiction of the courts of New South Wales.',
      ),

      _termSection(
        context: context,
        colours: colours,
        heading: '10. Changes to Terms',
        headingStyle: headingStyle,
        body:
            'Pickles may update these Terms from time to time. You will be notified of material changes through the application. Continued use of the application after notification constitutes acceptance of the updated terms.',
      ),

      const SizedBox(height: AppDimensions.spacingLg),

      Text(
        'Last updated: April 2026 · Version ${AppConstants.termsVersion}',
        style: AppTextStyles.labelSmall.copyWith(
          color: colours.onSurfaceVariant,
        ),
      ),
    ];
  }

  Widget _termSection({
    required BuildContext context,
    required ColourTokens colours,
    required String heading,
    required TextStyle headingStyle,
    required String body,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: AppTextStyles.titleMedium
                .copyWith(color: colours.onSurface)
                .merge(headingStyle),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colours.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
