abstract final class Routes {
  Routes._();

  // ── Unauthenticated ───────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String termsAcceptance = '/terms';

  // ── Post-login routing (Step 1a — v1.4) ──────────────────────────────────
  /// "How many items do you have to sell?" decision screen.
  /// Routes to [assetCategory] (1 item) or [bulkLead] (2+ items).
  static const String itemQuantityRouting = '/routing';

  // ── Single-item Long Form (1 item path) ───────────────────────────────────
  static const String assetCategory = '/submit/category';
  static const String assetForm = '/submit/form';
  static const String photoCapture = '/submit/photos';

  // ── Bulk Lead Capture (2+ items path) ─────────────────────────────────────
  static const String bulkLead = '/bulk-lead';
  static const String bulkLeadConfirmation = '/bulk-lead/confirmation';

  // ── Dashboard & status ────────────────────────────────────────────────────
  static const String dashboard = '/dashboard';
  static const String submissionDetail = '/submissions';
  static const String valuationResponse = '/valuation';

  // ── Account ────────────────────────────────────────────────────────────────
  static const String profile = '/profile';
  static const String help = '/help';
}
