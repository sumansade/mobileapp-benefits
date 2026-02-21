import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.visaBlue.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 64,
                  height: 64,
                  errorBuilder: (_, e, st) => Icon(
                    Icons.credit_card,
                    size: 64,
                    color: AppColors.visaBlue,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Benefits',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.visaBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Unlock exclusive card benefits\nand premium rewards.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              FilledButton(
                onPressed: () => context.go('/register'),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
