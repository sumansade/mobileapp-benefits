import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'router.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    runApp(_FirebaseErrorApp(error: e.toString()));
    return;
  }

  runApp(const BenefitsMvpApp());
}

/// Shown when Firebase fails to initialize (e.g. missing config).
class _FirebaseErrorApp extends StatelessWidget {
  const _FirebaseErrorApp({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Firebase initialization failed:\n\n$error\n\n'
              'Run: flutterfire configure --project=YOUR_PROJECT_ID',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class BenefitsMvpApp extends StatelessWidget {
  const BenefitsMvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter();
    return MaterialApp.router(
      title: 'Benefits',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
    );
  }
}
