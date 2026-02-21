import 'package:firebase_auth/firebase_auth.dart';

/// Wrapper around Firebase Auth for sign-up, sign-in, and sign-out.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Currently signed-in user (nullable).
  User? get currentUser => _auth.currentUser;

  /// Register with email & password. Returns the [UserCredential].
  Future<UserCredential> register(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign in with email & password.
  Future<UserCredential> signIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
