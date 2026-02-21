import 'package:flutter/material.dart';

import '../theme.dart';

/// App logo widget used in AppBar and Welcome screen.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 32, this.showText = true});

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          errorBuilder: (_, e, st) => Icon(
            Icons.credit_card,
            size: size,
            color: Colors.white,
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'Benefits',
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.w800,
              color: AppColors.visaBlue,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}
