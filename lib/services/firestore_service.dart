import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore helper for users, benefits, and orders collections.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ───── Users ─────

  /// Create user profile document after registration.
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String cardLast4,
    required String cardExpiry,
    required String cardBrand,
  }) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'cardLast4': cardLast4,
      'cardExpiry': cardExpiry,
      'cardBrand': cardBrand,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get user profile as a stream.
  Stream<DocumentSnapshot<Map<String, dynamic>>> userProfileStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  // ───── Benefits ─────

  /// Stream all benefits.
  Stream<QuerySnapshot<Map<String, dynamic>>> benefitsStream() {
    return _db.collection('benefits').snapshots();
  }

  /// Get a single benefit by ID.
  Future<DocumentSnapshot<Map<String, dynamic>>> getBenefit(String benefitId) {
    return _db.collection('benefits').doc(benefitId).get();
  }

  // ───── Orders ─────

  /// Create an order document.
  Future<DocumentReference<Map<String, dynamic>>> createOrder({
    required String uid,
    required String benefitId,
  }) async {
    return _db.collection('orders').add({
      'uid': uid,
      'benefitId': benefitId,
      'status': 'CONFIRMED',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
