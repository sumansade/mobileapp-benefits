import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/firestore_service.dart';
import '../theme.dart';

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

        return _DetailContent(
          benefitId: benefitId,
          data: data,
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.benefitId,
    required this.data,
  });

  final String benefitId;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final title = data['title'] as String? ?? '';
    final subtitle = data['subtitle'] as String? ?? '';
    final description = data['description'] as String? ?? '';
    final category = data['category'] as String? ?? '';
    final terms = data['terms'] as String? ?? '';
    final isCheckout = data['isCheckoutEnabled'] as bool? ?? false;
    final ctaText = data['ctaText'] as String? ?? 'Redeem';
    final imageUrl = data['imageUrl'] as String?;
    final eligibility = data['eligibility'] as String?;

    final valueProps = _toStringList(data['valueProps']);
    final howToRedeem = _toStringList(data['howToRedeem']);
    final faqList = _toFaqList(data['faq']);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                ),
              ),
              background: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, st) => Container(
                        color: AppColors.visaBlue,
                        child: const Center(
                          child: Icon(Icons.image,
                              size: 64, color: Colors.white30),
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.visaBlue,
                      child: const Center(
                        child:
                            Icon(Icons.image, size: 64, color: Colors.white30),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subtitle.isNotEmpty) ...[
                    Text(subtitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Chip(
                        label: Text(category),
                        backgroundColor: colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600),
                      ),
                      if (isCheckout) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: const Text('Redeemable'),
                          backgroundColor: AppColors.gold.withAlpha(40),
                          labelStyle: const TextStyle(
                              color: AppColors.goldDark,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 24),

                  // What you get
                  if (valueProps.isNotEmpty)
                    _sectionCard(
                      context,
                      title: 'What You Get',
                      icon: Icons.star_outline,
                      child: Column(
                        children: valueProps
                            .map((v) => _bulletItem(context, v))
                            .toList(),
                      ),
                    ),

                  // How to redeem
                  if (howToRedeem.isNotEmpty)
                    _sectionCard(
                      context,
                      title: 'How to Redeem',
                      icon: Icons.checklist,
                      child: Column(
                        children: howToRedeem
                            .asMap()
                            .entries
                            .map((e) =>
                                _numberedItem(context, e.key + 1, e.value))
                            .toList(),
                      ),
                    ),

                  // Eligibility
                  if (eligibility != null && eligibility.isNotEmpty)
                    _sectionCard(
                      context,
                      title: 'Eligibility',
                      icon: Icons.verified_user_outlined,
                      child: Text(eligibility,
                          style: theme.textTheme.bodyMedium),
                    ),

                  // Terms
                  if (terms.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: Icon(Icons.description_outlined,
                            color: colorScheme.primary),
                        title: const Text('Terms & Conditions',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(terms,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                )),
                          ),
                        ],
                      ),
                    ),

                  // FAQ
                  if (faqList.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.help_outline,
                                color: colorScheme.primary),
                            title: const Text('Frequently Asked Questions',
                                style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          ...faqList.map((faq) => ExpansionTile(
                                title: Text(faq['q'] ?? '',
                                    style: const TextStyle(fontSize: 14)),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 16),
                                    child: Text(faq['a'] ?? '',
                                        style:
                                            theme.textTheme.bodyMedium),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),

                  // Need help
                  _sectionCard(
                    context,
                    title: 'Need Help?',
                    icon: Icons.support_agent,
                    child: Text(
                      'Our support team is available 24/7 to assist you with any questions about this benefit. Contact us anytime.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),

                  // Spacer for bottom CTA
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      // Sticky bottom CTA
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: isCheckout
              ? FilledButton(
                  onPressed: () =>
                      context.go('/home/benefit/$benefitId/checkout'),
                  child: Text(ctaText),
                )
              : OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Done'),
                ),
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _bulletItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 18, color: AppColors.visaBlue),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _numberedItem(BuildContext context, int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.visaBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
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

  List<String> _toStringList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  List<Map<String, String>> _toFaqList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) {
        if (e is Map) {
          return {
            'q': e['q']?.toString() ?? '',
            'a': e['a']?.toString() ?? '',
          };
        }
        return <String, String>{};
      }).toList();
    }
    return [];
  }
}
