import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickles_direct/core/di/injection.dart';
import 'package:pickles_direct/core/router/routes.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/password_field.dart';
import 'package:pickles_direct/features/auth/presentation/widgets/pickles_logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  int _step = 0; // 0 = credentials, 1 = business profile

  // Step 0 fields
  final _step0Key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step0Key.currentState!.validate()) {
      setState(() => _step = 1);
    }
  }

  void _submit(BuildContext context) {
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureState) {
          // Registration failed — return to step 0 so user can correct fields.
          setState(() => _step = 0);
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
        if (state is AuthTermsRequired) {
          context.go(Routes.termsAcceptance);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: _step == 0
              ? BackButton(onPressed: () => context.pop())
              : BackButton(onPressed: () => setState(() => _step = 0)),
          title: const PicklesLogo(size: LogoSize.small),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacingMd),
              child: _StepIndicator(currentStep: _step, totalSteps: 2),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          child: _step == 0
              ? _CredentialsStep(
                  key: const ValueKey('step0'),
                  formKey: _step0Key,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  onNext: _nextStep,
                )
              : _BusinessProfileStep(
                  key: const ValueKey('step1'),
                  onSubmit: () => _submit(context),
                ),
        ),
      ),
    );
  }
}

// ── Step 0: Account credentials ───────────────────────────────────────────────

class _CredentialsStep extends StatelessWidget {
  const _CredentialsStep({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNext,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.spacingLg),

            Text(
              'Create your account',
              style: AppTextStyles.headlineMedium
                  .copyWith(color: colours.onSurface),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              'Step 1 of 2 — Account details',
              style: AppTextStyles.bodySmall
                  .copyWith(color: colours.onSurfaceVariant),
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Full name *',
                hintText: 'e.g. David Harper',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your full name.'
                  : null,
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email address *',
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

            const SizedBox(height: AppDimensions.spacingMd),

            PasswordField(
              controller: passwordController,
              label: 'Password *',
              hint: 'Min. 8 characters',
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter a password.';
                if (v.length < 8) {
                  return 'Password must be at least 8 characters.';
                }
                return null;
              },
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            PasswordField(
              controller: confirmPasswordController,
              label: 'Confirm password *',
              validator: (v) {
                if (v != passwordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            ElevatedButton(
              onPressed: onNext,
              child: const Text('Continue'),
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: colours.onSurfaceVariant),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Sign in'),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingLg),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Business profile ──────────────────────────────────────────────────

class _BusinessProfileStep extends StatefulWidget {
  const _BusinessProfileStep({required this.onSubmit, super.key});
  final VoidCallback onSubmit;

  @override
  State<_BusinessProfileStep> createState() => _BusinessProfileStepState();
}

class _BusinessProfileStepState extends State<_BusinessProfileStep> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _abnController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _abnController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms || !_agreedToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the Terms & Conditions and Privacy Policy to continue.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.spacingLg),

            Text(
              'Business profile',
              style: AppTextStyles.headlineMedium
                  .copyWith(color: colours.onSurface),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              'Step 2 of 2 — Required to verify your identity and process payments',
              style: AppTextStyles.bodySmall
                  .copyWith(color: colours.onSurfaceVariant),
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            TextFormField(
              controller: _businessNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Business name *',
                hintText: 'e.g. Harper Fleet Management',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your business name.'
                  : null,
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            TextFormField(
              controller: _abnController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ABN *',
                hintText: 'e.g. 12 345 678 901',
                helperText: 'Your 11-digit Australian Business Number',
              ),
              validator: _validateAbn,
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Mobile number *',
                hintText: 'e.g. 0412 345 678',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your mobile number.'
                  : null,
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // ── Consent checkboxes (BR-55, BRU-18) ─────────────────────────
            _ConsentCheckbox(
              value: _agreedToTerms,
              onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
              label: 'I agree to the ',
              linkLabel: 'Terms & Conditions',
              onLinkTap: () => context.push(Routes.termsAcceptance),
            ),

            const SizedBox(height: AppDimensions.spacingSm),

            _ConsentCheckbox(
              value: _agreedToPrivacy,
              onChanged: (v) => setState(() => _agreedToPrivacy = v ?? false),
              label: 'I have read and accept the ',
              linkLabel: 'Privacy Policy',
              onLinkTap: () {/* TODO(pickles): open privacy policy URL */},
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final loading = state is AuthLoading;
                return ElevatedButton(
                  onPressed:
                      loading ? null : () => _submit(context),
                  child: loading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create Account'),
                );
              },
            ),

            const SizedBox(height: AppDimensions.spacingLg),
          ],
        ),
      ),
    );
  }

  String? _validateAbn(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your ABN.';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) {
      return 'ABN must be 11 digits.';
    }
    // ABN checksum validation (Australian Tax Office algorithm).
    final weights = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
    var sum = 0;
    for (var i = 0; i < 11; i++) {
      final digit = int.parse(digits[i]);
      sum += (i == 0 ? digit - 1 : digit) * weights[i];
    }
    if (sum % 89 != 0) {
      return 'This ABN appears to be invalid. Please check and try again.';
    }
    return null;
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _ConsentCheckbox extends StatelessWidget {
  const   _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.linkLabel,
    required this.onLinkTap,
    // ignore: unused_element_parameter — private widget, no super.key needed
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final String linkLabel;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const SizedBox(width: AppDimensions.spacingXs),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Wrap(
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: colours.onSurfaceVariant),
                ),
                GestureDetector(
                  onTap: onLinkTap,
                  child: Text(
                    linkLabel,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${currentStep + 1} / $totalSteps',
      style: AppTextStyles.labelMedium.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
