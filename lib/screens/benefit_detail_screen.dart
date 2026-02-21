import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/firestore_service.dart';

class BenefitDetailScreen extends StatelessWidget {
  const BenefitDetailScreen({super.key, required this.benefitId});
  final String benefitId;

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: firestoreService.getBenefit(benefitId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Benefit')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data?.data();
        if (data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Benefit')),
            body: const Center(child: Text('Benefit not found.')),
          );
        }

        final title = data['title'] as String? ?? '';
        final description = data['description'] as String? ?? '';
        final terms = data['terms'] as String? ?? '';
        final category = data['category'] as String? ?? '';
        final isCheckout = data['isCheckoutEnabled'] as bool? ?? false;

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(label: Text(category)),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Text(
                  'Terms & Conditions',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  terms,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(179),
                      ),
                ),
                if (isCheckout) ...[
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () =>
                        context.go('/home/benefit/$benefitId/checkout'),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Checkout'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
