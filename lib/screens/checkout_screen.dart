import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.benefitId});
  final String benefitId;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  bool _loadingBenefit = true;
  bool _processing = false;
  String? _error;
  Map<String, dynamic>? _benefitData;

  @override
  void initState() {
    super.initState();
    _loadBenefit();
  }

  Future<void> _loadBenefit() async {
    try {
      final snap = await _firestoreService.getBenefit(widget.benefitId);
      if (mounted) {
        setState(() {
          _benefitData = snap.data();
          _loadingBenefit = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loadingBenefit = false;
        });
      }
    }
  }

  String _generateConfirmationId() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const digits = '0123456789';
    final rng = Random();
    final letterPart =
        List.generate(4, (_) => chars[rng.nextInt(chars.length)]).join();
    final digitPart =
        List.generate(4, (_) => digits[rng.nextInt(digits.length)]).join();
    return '$letterPart-$digitPart';
  }

  Future<void> _confirm() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null || _benefitData == null) return;

    setState(() {
      _processing = true;
      _error = null;
    });

    // Simulate processing delay for premium feel
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    try {
      final confirmationId = _generateConfirmationId();
      final title = _benefitData!['title'] as String? ?? '';
      final redemptionType =
          _benefitData!['redemptionType'] as String? ?? 'voucher';

      await _firestoreService.createOrder(
        uid: uid,
        benefitId: widget.benefitId,
        benefitTitle: title,
        redemptionType: redemptionType,
        confirmationId: confirmationId,
      );

      if (mounted) {
        context.go(
          '/home/benefit/${widget.benefitId}/confirmation',
          extra: {
            'confirmationId': confirmationId,
            'benefitTitle': title,
            'redemptionType': redemptionType,
          },
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loadingBenefit) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_processing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: AppColors.visaBlue,
                ),
              ),
              const SizedBox(height: 24),
              Text('Processing your redemption...',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Please wait',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final title = _benefitData?['title'] as String? ?? 'Benefit';
    final description = _benefitData?['description'] as String? ?? '';
    final ctaText = _benefitData?['ctaText'] as String? ?? 'Confirm';
    final redemptionType =
        _benefitData?['redemptionType'] as String? ?? 'voucher';

    return Scaffold(
      appBar: AppBar(title: const Text('Review & Confirm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Benefit summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        redemptionType.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.goldDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // What happens next
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text('What happens next',
                            style: theme.textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _nextStepItem(context, '1',
                        'Your redemption will be confirmed instantly'),
                    _nextStepItem(
                        context, '2', 'You\'ll receive a confirmation ID'),
                    _nextStepItem(context, '3',
                        'View details anytime in My Redemptions'),
                  ],
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _confirm,
            child: Text(ctaText),
          ),
        ),
      ),
    );
  }

  Widget _nextStepItem(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.visaBlue.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: AppColors.visaBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
