import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/pickles_logo.dart';

/// Resolves authentication state and redirects accordingly.
///
/// Shown at app launch. Dispatches [AuthCheckRequested] and listens for the
/// first terminal auth state before handing off to the router.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthAuthenticated():
            context.go(Routes.dashboard);
          case AuthUnauthenticated():
            context.go(Routes.login);
          case AuthTermsRequired():
            context.go(Routes.termsAcceptance);
          default:
            break;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo ────────────────────────────────────────────────
                const PicklesLogo(size: LogoSize.large),

                const SizedBox(height: AppDimensions.spacingXxl),

                // ── Branded loading indicator ─────────────────────────
                SizedBox.square(
                  dimension: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingMd),

                Text(
                  'Loading…',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? AppColours.dark
                            : AppColours.light)
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
