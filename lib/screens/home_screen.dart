import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/seed_service.dart';
import '../theme.dart';
import '../widgets/benefit_card.dart';
import '../widgets/premium_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final _seedService = SeedService();

  bool _seeding = true;
  String _selectedCategory = 'All';
  bool _showSavedOnly = false;

  static const _categories = [
    'All',
    'Travel',
    'Dining',
    'Protection',
    'Lifestyle',
    'Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _runSeed();
  }

  Future<void> _runSeed() async {
    try {
      await _seedService.seedIfNeeded();
    } catch (_) {
      // Seeding failure is non-fatal for MVP.
    }
    if (mounted) {
      setState(() => _seeding = false);
    }
  }

  void _showCardDetails(String brand, String last4, String expiry) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Card Details',
                style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            _detailRow('Brand', brand),
            _detailRow('Card Number', '$brand ···· $last4'),
            _detailRow('Expires', expiry),
            _detailRow('Tier', 'Visa Infinite'),
            _detailRow('Status', 'Active'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              errorBuilder: (_, e, st) => const Icon(
                Icons.credit_card,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Benefits'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showSavedOnly ? Icons.bookmark : Icons.bookmark_border,
              color: _showSavedOnly ? AppColors.gold : Colors.white,
            ),
            tooltip: 'Saved Benefits',
            onPressed: () {
              setState(() => _showSavedOnly = !_showSavedOnly);
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'My Redemptions',
            onPressed: () => context.go('/home/redemptions'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
      body: _seeding
          ? const Center(child: CircularProgressIndicator())
          : _HomeBody(
              uid: user.uid,
              firestoreService: _firestoreService,
              selectedCategory: _selectedCategory,
              showSavedOnly: _showSavedOnly,
              categories: _categories,
              onCategoryChanged: (cat) {
                setState(() => _selectedCategory = cat);
              },
              onShowCardDetails: _showCardDetails,
            ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.uid,
    required this.firestoreService,
    required this.selectedCategory,
    required this.showSavedOnly,
    required this.categories,
    required this.onCategoryChanged,
    required this.onShowCardDetails,
  });

  final String uid;
  final FirestoreService firestoreService;
  final String selectedCategory;
  final bool showSavedOnly;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;
  final void Function(String brand, String last4, String expiry)
      onShowCardDetails;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firestoreService.userProfileStream(uid),
      builder: (context, userSnap) {
        final userData = userSnap.data?.data();
        final brand = userData?['cardBrand'] as String? ?? 'VISA';
        final last4 = userData?['cardLast4'] as String? ?? '····';
        final expiry = userData?['cardExpiry'] as String? ?? '--/--';

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestoreService.savedBenefitsStream(uid),
          builder: (context, savedSnap) {
            final savedIds = <String>{};
            if (savedSnap.hasData) {
              for (final doc in savedSnap.data!.docs) {
                savedIds.add(doc.id);
              }
            }

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.benefitsStream(),
              builder: (context, benefitsSnap) {
                return CustomScrollView(
                  slivers: [
                    // Premium card header
                    SliverToBoxAdapter(
                      child: PremiumCardWidget(
                        brand: brand,
                        last4: last4,
                        expiry: expiry,
                        onViewDetails: () =>
                            onShowCardDetails(brand, last4, expiry),
                      ),
                    ),
                    // Category filter chips
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: categories.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final isSelected = cat == selectedCategory;
                            return FilterChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (_) => onCategoryChanged(cat),
                              selectedColor:
                                  AppColors.visaBlue.withAlpha(30),
                              checkmarkColor: AppColors.visaBlue,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.visaBlue
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 8),
                    ),
                    // Benefits list
                    _buildBenefitsList(
                        context, benefitsSnap, savedIds),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBenefitsList(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    Set<String> savedIds,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.card_giftcard, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('No benefits available.',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    var docs = snapshot.data!.docs;

    // Filter by category
    if (selectedCategory != 'All') {
      docs = docs.where((doc) {
        final cat = doc.data()['category'] as String? ?? '';
        return cat == selectedCategory;
      }).toList();
    }

    // Filter by saved
    if (showSavedOnly) {
      docs = docs.where((doc) => savedIds.contains(doc.id)).toList();
    }

    if (docs.isEmpty) {
      final msg = showSavedOnly
          ? 'No saved benefits yet.\nTap the bookmark icon on a benefit to save it.'
          : 'No benefits in this category.';
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  showSavedOnly ? Icons.bookmark_border : Icons.search_off,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final doc = docs[index];
          final data = doc.data();
          final title = data['title'] as String? ?? '';
          final subtitle = data['subtitle'] as String? ??
              data['description'] as String? ??
              '';
          final category = data['category'] as String? ?? '';
          final isCheckout =
              data['isCheckoutEnabled'] as bool? ?? false;
          final imageUrl = data['imageUrl'] as String?;
          final ctaText = data['ctaText'] as String?;
          final isSaved = savedIds.contains(doc.id);

          return BenefitCard(
            title: title,
            subtitle: subtitle,
            category: category,
            isCheckoutEnabled: isCheckout,
            isSaved: isSaved,
            imageUrl: imageUrl,
            ctaText: ctaText,
            onTap: () => context.go('/home/benefit/${doc.id}'),
            onToggleSave: () async {
              final svc = FirestoreService();
              final saved = await svc.toggleSavedBenefit(uid, doc.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      saved
                          ? '"$title" saved'
                          : '"$title" removed from saved',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          );
        },
        childCount: docs.length,
      ),
    );
  }
}
