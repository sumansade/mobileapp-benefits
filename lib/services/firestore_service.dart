import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore helper for users, benefits, orders, and saved benefits.
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

  /// Create an order document with enhanced fields.
  Future<DocumentReference<Map<String, dynamic>>> createOrder({
    required String uid,
    required String benefitId,
    required String benefitTitle,
    String redemptionType = 'voucher',
    required String confirmationId,
  }) async {
    return _db.collection('orders').add({
      'uid': uid,
      'benefitId': benefitId,
      'benefitTitle': benefitTitle,
      'status': 'CONFIRMED',
      'confirmationId': confirmationId,
      'redemptionType': redemptionType,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream orders for a user, ordered by createdAt descending.
  Stream<QuerySnapshot<Map<String, dynamic>>> ordersStream(String uid) {
    return _db
        .collection('orders')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ───── Saved Benefits ─────

  /// Stream all saved benefit IDs for a user.
  Stream<QuerySnapshot<Map<String, dynamic>>> savedBenefitsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('savedBenefits')
        .snapshots();
  }

  /// Toggle saved state for a benefit.
  Future<bool> toggleSavedBenefit(String uid, String benefitId) async {
    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('savedBenefits')
        .doc(benefitId);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.delete();
      return false;
    } else {
      await ref.set({'savedAt': FieldValue.serverTimestamp()});
      return true;
    }
  }
}
