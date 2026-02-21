import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({
    super.key,
    this.confirmationId,
    this.benefitTitle,
    this.redemptionType,
  });

  final String? confirmationId;
  final String? benefitTitle;
  final String? redemptionType;

  String _generateMockVoucher() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';
    final rng = Random();
    return List.generate(16, (i) {
      if (i > 0 && i % 4 == 0) return '-';
      return chars[rng.nextInt(chars.length)];
    }).join().replaceAll('--', '-');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confId = confirmationId ?? 'N/A';
    final title = benefitTitle ?? 'Benefit';
    final isVoucher = redemptionType == 'voucher';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 56,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Confirmed!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Confirmation ID card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Confirmation ID',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        confId,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.visaBlue,
                          letterSpacing: 2,
                        ),
                      ),
                      if (isVoucher) ...[
                        const Divider(height: 24),
                        Text(
                          'Voucher Code',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _generateMockVoucher(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.goldDark,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Benefits'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/home/redemptions'),
                child: const Text('View My Redemptions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
