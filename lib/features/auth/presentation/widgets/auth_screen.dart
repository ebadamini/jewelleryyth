import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/localization/locale_cubit.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/components/layout/responsive_container.dart';
import '../bloc/auth_bloc.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.initialMode,
  });

  final AuthMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthModeChanged(widget.initialMode));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: Localizations.localeOf(context).languageCode == 'fa'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: ResponsiveContainer(
          child: SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.success) {
                  Navigator.of(context).pushReplacementNamed(AppRouter.dashboardRoute);
                }

                if (state.status == AuthStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? l10n.translate('genericError')),
                    ),
                  );
                }
              },

              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: isMobile
                      ? SingleChildScrollView(
                    child: Column(
                      children: [
                        _AuthHero(l10n: l10n, compact: true),
                        const SizedBox(height: 24),
                        _AuthCard(state: state, compact: true),
                      ],
                    ),
                  )
                      : Row(
                    children: [
                      Expanded(flex: 11, child: _AuthHero(l10n: l10n)),
                      const SizedBox(width: 24),
                      Expanded(flex: 9, child: _AuthCard(state: state)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({
    required this.l10n,
    this.compact = false,
  });

  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();

    return Container(
      padding: EdgeInsets.all(compact ? 24 : 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF111111), Color(0xFF2B2B2B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.diamond_outlined, color: Colors.white),
              ),
              const Spacer(),
              SegmentedButton<String>(
                selected: {Localizations.localeOf(context).languageCode},
                onSelectionChanged: (value) {
                  localeCubit.switchLocale(value.first);
                },
                segments: [
                  ButtonSegment(value: 'en', label: Text(l10n.translate('english'))),
                  ButtonSegment(value: 'fa', label: Text(l10n.translate('persian'))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            l10n.translate('authFeatureTitle'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.translate('authFeatureSubtitle'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 24),
          _BenefitTile(text: l10n.translate('featureResponsive')),
          const SizedBox(height: 12),
          _BenefitTile(text: l10n.translate('featureApiReady')),
          const SizedBox(height: 12),
          _BenefitTile(text: l10n.translate('featureBilingual')),
          const SizedBox(height: 24),
          // Text(
          //   l10n.translate('backendReadyHint'),
          //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //     color: Colors.white.withValues(alpha: 0.62),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.state,
    this.compact = false,
  });

  final AuthState state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.mode == AuthMode.login
                  ? l10n.translate('welcomeBack')
                  : l10n.translate('createAccount'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.mode == AuthMode.login
                  ? l10n.translate('welcomeBackSubtitle')
                  : l10n.translate('createAccountSubtitle'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            if (compact)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: state.mode == AuthMode.login
                    ? const LoginForm(key: ValueKey('login-form'), compact: true)
                    : const SignupForm(key: ValueKey('signup-form'), compact: true),
              )
            else
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: state.mode == AuthMode.login
                      ? const LoginForm(key: ValueKey('login-form'))
                      : const SignupForm(key: ValueKey('signup-form')),
                ),
              ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  final isLogin = state.mode == AuthMode.login;
                  context.read<AuthBloc>().add(
                    AuthModeChanged(isLogin ? AuthMode.signup : AuthMode.login),
                  );
                  Navigator.of(context).pushReplacementNamed(
                    isLogin ? AppRouter.signupRoute : AppRouter.loginRoute,
                  );
                },
                child: Text(
                  state.mode == AuthMode.login
                      ? '${l10n.translate('dontHaveAccount')} ${l10n.translate('signUpNow')}'
                      : '${l10n.translate('alreadyHaveAccount')} ${l10n.translate('signInNow')}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
