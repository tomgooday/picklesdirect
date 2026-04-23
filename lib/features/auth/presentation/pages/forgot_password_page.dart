import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/pickles_logo.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      AuthForgotPasswordRequested(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          setState(() => _submitted = true);
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
          leading: BackButton(onPressed: () => context.pop()),
          title: const PicklesLogo(size: LogoSize.small),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
            ),
            child: _submitted
                ? _SuccessView(email: _emailController.text.trim())
                : _FormView(
                    formKey: _formKey,
                    emailController: _emailController,
                    colours: colours,
                    onSubmit: () => _submit(context),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _FormView extends StatelessWidget {
  const _FormView({
    required this.formKey,
    required this.emailController,
    required this.colours,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final ColourTokens colours;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacingLg),

          // ── Icon ────────────────────────────────────────────────────────
          Icon(
            Icons.lock_reset_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          Text(
            'Reset your password',
            style: AppTextStyles.headlineMedium.copyWith(
              color: colours.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacingXs),

          Text(
            "Enter the email address linked to your account and we'll send you a reset link.",
            style: AppTextStyles.bodyMedium.copyWith(
              color: colours.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            onFieldSubmitted: (_) => onSubmit(),
            decoration: const InputDecoration(
              labelText: 'Email address',
              hintText: 'you@yourcompany.com.au',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your email address.';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final loading = state is AuthLoading;
              return ElevatedButton(
                onPressed: loading ? null : onSubmit,
                child: loading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Send Reset Link'),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Success ───────────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.mark_email_read_rounded,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        Text(
          'Check your inbox',
          style: AppTextStyles.headlineMedium.copyWith(
            color: colours.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacingXs),

        Text(
          "We've sent a password reset link to\n$email",
          style: AppTextStyles.bodyMedium.copyWith(
            color: colours.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacingXl),

        ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }
}
