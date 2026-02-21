import 'package:flutter/material.dart';

import '../theme.dart';

/// Premium gradient card displaying card summary on Home screen.
class PremiumCardWidget extends StatelessWidget {
  const PremiumCardWidget({
    super.key,
    required this.brand,
    required this.last4,
    required this.expiry,
    this.onViewDetails,
  });

  final String brand;
  final String last4;
  final String expiry;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardGradientStart,
            AppColors.cardGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.visaBlue.withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Visa Infinite',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Icon(
                  Icons.contactless_outlined,
                  color: Colors.white.withAlpha(180),
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              '$brand  ••••  $last4',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXPIRES',
                      style: TextStyle(
                        color: Colors.white.withAlpha(150),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      expiry,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (onViewDetails != null)
                  TextButton(
                    onPressed: onViewDetails,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white.withAlpha(80)),
                      ),
                    ),
                    child: const Text(
                      'View details',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
