import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/config/app_config.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/auth_divider.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/microsoft_sign_in_button.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/password_field.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/pickles_logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthSignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
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
        if (state is AccountSuspendedFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // ── Logo ─────────────────────────────────────────────────
                  const Center(child: PicklesLogo(size: LogoSize.large)),

                  const SizedBox(height: AppDimensions.spacingXxl),

                  // ── Heading ───────────────────────────────────────────────
                  Text(
                    'Sign in',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: _colours(context).onSurface,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingXs),

                  Text(
                    'Welcome back. Sign in to continue.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _colours(context).onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // ── Email ─────────────────────────────────────────────────
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                    validator: _validateEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      hintText: 'you@yourcompany.com.au',
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingMd),

                  // ── Password ──────────────────────────────────────────────
                  PasswordField(
                    controller: _passwordController,
                    onFieldSubmitted: (_) => _submit(context),
                    validator: _validatePassword,
                  ),

                  // ── Forgot password ────────────────────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          context.push(Routes.forgotPassword),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingXs,
                        ),
                      ),
                      child: const Text('Forgot password?'),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  // ── Sign in button ─────────────────────────────────────────
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final loading = state is AuthLoading;
                      return ElevatedButton(
                        onPressed: loading ? null : () => _submit(context),
                        child: loading
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Sign In'),
                      );
                    },
                  ),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // ── Divider ────────────────────────────────────────────────
                  const AuthDivider(),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // ── Microsoft SSO ─────────────────────────────────────────
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final loading = state is AuthLoading;
                      final msalConfigured =
                          getIt<AppConfig>().azureClientId.isNotEmpty;
                      return MicrosoftSignInButton(
                        isLoading: loading,
                        // Disabled until Azure Entra client ID is configured.
                        onPressed: msalConfigured
                            ? () => context.read<AuthBloc>().add(
                                  const AuthMsalSignInRequested(),
                                )
                            : null,
                      );
                    },
                  ),

                  const SizedBox(height: AppDimensions.spacingXxl),

                  // ── Register link ─────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ", // apostrophe requires double-quotes
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _colours(context).onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(Routes.register),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Register'),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spacingLg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ColourTokens _colours(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColours.dark
          : AppColours.light;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    return null;
  }
}
