import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/seed_service.dart';
import '../utils/card_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _seedService = SeedService();

  bool _seeding = true;

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

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Benefits'),
        actions: [
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
      body: Column(
        children: [
          _CardSummary(uid: user.uid),
          const Divider(height: 1),
          Expanded(
            child: _seeding
                ? const Center(child: CircularProgressIndicator())
                : const _BenefitsList(),
          ),
        ],
      ),
    );
  }
}

// ───── Card Summary ─────

class _CardSummary extends StatelessWidget {
  const _CardSummary({required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firestoreService.userProfileStream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data?.data();
        if (data == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No card on file'),
          );
        }

        final brand = data['cardBrand'] as String? ?? 'OTHER';
        final last4 = data['cardLast4'] as String? ?? '????';
        final expiry = data['cardExpiry'] as String? ?? '--/--';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maskedCardDisplay(brand, last4),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Expires $expiry',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ───── Benefits List ─────

class _BenefitsList extends StatelessWidget {
  const _BenefitsList();

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'travel':
        return Icons.flight;
      case 'cashback':
        return Icons.attach_money;
      case 'protection':
        return Icons.shield;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestoreService.benefitsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No benefits available.'));
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: docs.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();
            final title = data['title'] as String? ?? '';
            final description = data['description'] as String? ?? '';
            final category = data['category'] as String? ?? '';
            final isCheckout = data['isCheckoutEnabled'] as bool? ?? false;

            return ListTile(
              leading: Icon(_categoryIcon(category)),
              title: Text(title),
              subtitle: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: isCheckout
                  ? const Icon(Icons.shopping_cart_outlined, size: 20)
                  : null,
              onTap: () => context.go('/home/benefit/${doc.id}'),
            );
          },
        );
      },
    );
  }
}
