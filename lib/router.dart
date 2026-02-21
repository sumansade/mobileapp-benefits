import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/benefit_detail_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/redemptions_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';

/// Application router with auth-gate redirect logic.
GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = FirebaseAuth.instance.currentUser != null;
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/';

      if (!loggedIn && !loggingIn) {
        return '/';
      }
      if (loggedIn && loggingIn) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'redemptions',
            builder: (context, state) => const RedemptionsScreen(),
          ),
          GoRoute(
            path: 'benefit/:benefitId',
            builder: (context, state) {
              final benefitId = state.pathParameters['benefitId']!;
              return BenefitDetailScreen(benefitId: benefitId);
            },
            routes: [
              GoRoute(
                path: 'checkout',
                builder: (context, state) {
                  final benefitId = state.pathParameters['benefitId']!;
                  return CheckoutScreen(benefitId: benefitId);
                },
              ),
              GoRoute(
                path: 'confirmation',
                builder: (context, state) {
                  final extra = state.extra;
                  String? confirmationId;
                  String? benefitTitle;
                  String? redemptionType;
                  if (extra is Map<String, dynamic>) {
                    confirmationId = extra['confirmationId'] as String?;
                    benefitTitle = extra['benefitTitle'] as String?;
                    redemptionType = extra['redemptionType'] as String?;
                  }
                  return ConfirmationScreen(
                    confirmationId: confirmationId,
                    benefitTitle: benefitTitle,
                    redemptionType: redemptionType,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
