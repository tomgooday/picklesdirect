import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/router/router_notifier.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/features/asset_capture/presentation/pages/asset_category_page.dart';
import 'package:pickles_direct/features/asset_capture/presentation/pages/asset_form_page.dart';
import 'package:pickles_direct/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:pickles_direct/features/auth/presentation/pages/login_page.dart';
import 'package:pickles_direct/features/auth/presentation/pages/register_page.dart';
import 'package:pickles_direct/features/auth/presentation/pages/splash_page.dart';
import 'package:pickles_direct/features/auth/presentation/pages/terms_acceptance_page.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/pages/bulk_lead_confirmation_page.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/pages/bulk_lead_page.dart';
import 'package:pickles_direct/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:pickles_direct/features/help/presentation/pages/help_page.dart';
import 'package:pickles_direct/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pickles_direct/features/photo_capture/presentation/pages/photo_capture_page.dart';
import 'package:pickles_direct/features/profile/presentation/pages/profile_page.dart';
import 'package:pickles_direct/features/routing/presentation/pages/item_quantity_routing_page.dart';
import 'package:pickles_direct/features/submission_status/presentation/pages/submission_detail_page.dart';
import 'package:pickles_direct/features/valuation/presentation/pages/valuation_response_page.dart';

class AppRouter {
  AppRouter(this._routerNotifier);

  final RouterNotifier _routerNotifier;

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    refreshListenable: _routerNotifier,
    redirect: _routerNotifier.redirect,
    routes: _buildRoutes(),
  );

  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  List<RouteBase> _buildRoutes() => [
    // ── Unauthenticated ────────────────────────────────────────────────
    GoRoute(
      path: Routes.splash,
      name: 'splash',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.onboarding,
      name: 'onboarding',
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.login,
      name: 'login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.register,
      name: 'register',
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      name: 'forgotPassword',
      builder: (_, __) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: Routes.termsAcceptance,
      name: 'termsAcceptance',
      builder: (_, __) => const TermsAcceptancePage(),
    ),

    // ── Post-login routing (Step 1a) ───────────────────────────────────
    GoRoute(
      path: Routes.itemQuantityRouting,
      name: 'itemQuantityRouting',
      builder: (_, __) => const ItemQuantityRoutingPage(),
    ),

    // ── Bulk Lead Capture (2+ items path) ──────────────────────────────
    GoRoute(
      path: Routes.bulkLead,
      name: 'bulkLead',
      builder: (_, __) => const BulkLeadPage(),
    ),
    GoRoute(
      path: Routes.bulkLeadConfirmation,
      name: 'bulkLeadConfirmation',
      builder: (_, __) => const BulkLeadConfirmationPage(),
    ),

    // ── Authenticated shell ────────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => _MainShell(child: child),
      routes: [
        GoRoute(
          path: Routes.dashboard,
          name: 'dashboard',
          builder: (_, __) => const DashboardPage(),
        ),

        // ── Single-item Long Form ────────────────────────────────────
        GoRoute(
          path: Routes.assetCategory,
          name: 'assetCategory',
          builder: (_, __) => const AssetCategoryPage(),
        ),
        GoRoute(
          path: '${Routes.assetForm}/:categoryKey',
          name: 'assetForm',
          builder: (_, state) => AssetFormPage(
            categoryKey: state.pathParameters['categoryKey']!,
            draftId: state.uri.queryParameters['draftId'],
          ),
        ),
        GoRoute(
          path: '${Routes.photoCapture}/:draftId',
          name: 'photoCapture',
          builder: (_, state) =>
              PhotoCapturePage(draftId: state.pathParameters['draftId']!),
        ),

        // ── Submission & valuation ───────────────────────────────────
        GoRoute(
          path: '${Routes.submissionDetail}/:submissionId',
          name: 'submissionDetail',
          builder: (_, state) => SubmissionDetailPage(
            submissionId: state.pathParameters['submissionId']!,
          ),
        ),
        GoRoute(
          path: '${Routes.valuationResponse}/:submissionId',
          name: 'valuationResponse',
          builder: (_, state) => ValuationResponsePage(
            submissionId: state.pathParameters['submissionId']!,
          ),
        ),

        // ── Account ──────────────────────────────────────────────────
        GoRoute(
          path: Routes.profile,
          name: 'profile',
          builder: (_, __) => const ProfilePage(),
        ),
        GoRoute(
          path: Routes.help,
          name: 'help',
          builder: (_, __) => const HelpPage(),
        ),
      ],
    ),
  ];
}

class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
