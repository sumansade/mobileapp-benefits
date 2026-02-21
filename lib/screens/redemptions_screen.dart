import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../theme.dart';

class RedemptionsScreen extends StatelessWidget {
  const RedemptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUser?.uid;
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Redemptions')),
        body: const Center(child: Text('Not signed in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Redemptions')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirestoreService().ordersStream(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Unable to load redemptions.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No redemptions yet.',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('Redeem a benefit to see it here.',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return _RedemptionCard(data: data);
            },
          );
        },
      ),
    );
  }
}

class _RedemptionCard extends StatelessWidget {
  const _RedemptionCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final benefitTitle =
        data['benefitTitle'] as String? ?? 'Benefit';
    final confirmationId =
        data['confirmationId'] as String? ?? 'N/A';
    final status = data['status'] as String? ?? 'UNKNOWN';
    final redemptionType =
        data['redemptionType'] as String? ?? '';
    final createdAt = data['createdAt'] as Timestamp?;

    String dateStr = '';
    if (createdAt != null) {
      final dt = createdAt.toDate();
      dateStr =
          '${dt.month}/${dt.day}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      benefitTitle,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  _statusPill(status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.confirmation_number_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    confirmationId,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.visaBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (dateStr.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(dateStr,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey)),
              ],
              if (redemptionType.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    redemptionType.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg;
    Color fg;
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        bg = Colors.green.withAlpha(30);
        fg = Colors.green.shade700;
      default:
        bg = Colors.grey.withAlpha(30);
        fg = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final benefitTitle =
        data['benefitTitle'] as String? ?? 'Benefit';
    final confirmationId =
        data['confirmationId'] as String? ?? 'N/A';
    final status = data['status'] as String? ?? 'UNKNOWN';
    final redemptionType =
        data['redemptionType'] as String? ?? '';
    final createdAt = data['createdAt'] as Timestamp?;

    String dateStr = '';
    if (createdAt != null) {
      final dt = createdAt.toDate();
      dateStr =
          '${dt.month}/${dt.day}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

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
            Text('Redemption Details',
                style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            _row('Benefit', benefitTitle),
            _row('Confirmation ID', confirmationId),
            _row('Status', status),
            if (redemptionType.isNotEmpty)
              _row('Type', redemptionType),
            if (dateStr.isNotEmpty) _row('Date', dateStr),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
