import 'package:flutter/material.dart';

import '../theme.dart';

/// Editorial benefit card with image, title, subtitle, chips, and bookmark.
class BenefitCard extends StatelessWidget {
  const BenefitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.isCheckoutEnabled,
    required this.isSaved,
    this.imageUrl,
    this.ctaText,
    required this.onTap,
    required this.onToggleSave,
  });

  final String title;
  final String subtitle;
  final String category;
  final bool isCheckoutEnabled;
  final bool isSaved;
  final String? imageUrl;
  final String? ctaText;
  final VoidCallback onTap;
  final VoidCallback onToggleSave;

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'travel':
        return Icons.flight_takeoff;
      case 'dining':
        return Icons.restaurant;
      case 'protection':
        return Icons.verified_user;
      case 'entertainment':
        return Icons.celebration;
      case 'lifestyle':
        return Icons.spa;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image banner with bookmark overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, e, st) => _placeholderImage(
                                colorScheme, _categoryIcon(category)),
                          )
                        : _placeholderImage(
                            colorScheme, _categoryIcon(category)),
                  ),
                ),
                // Bookmark overlay top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black.withAlpha(100),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onToggleSave,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? AppColors.gold : Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _chip(
                        context,
                        icon: _categoryIcon(category),
                        label: category,
                        color: colorScheme.primaryContainer,
                        textColor: colorScheme.onPrimaryContainer,
                      ),
                      if (isCheckoutEnabled) ...[
                        const SizedBox(width: 8),
                        _chip(
                          context,
                          label: 'Redeemable',
                          color: AppColors.gold.withAlpha(40),
                          textColor: AppColors.goldDark,
                        ),
                      ],
                      const Spacer(),
                      if (isCheckoutEnabled)
                        FilledButton(
                          onPressed: onTap,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text(ctaText ?? 'Redeem'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage(ColorScheme colorScheme, IconData icon) {
    return Container(
      color: colorScheme.surfaceContainerHigh,
      child: Center(
        child: Icon(icon, size: 48, color: colorScheme.primary.withAlpha(120)),
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    IconData? icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
