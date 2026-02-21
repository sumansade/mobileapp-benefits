import 'package:cloud_firestore/cloud_firestore.dart';

/// Seeds sample benefit documents on first launch.
class SeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Check if seeding has been done; if not, seed benefits.
  Future<void> seedIfNeeded() async {
    final metaDoc = _db.collection('_meta').doc('seed');
    final snapshot = await metaDoc.get();

    if (snapshot.exists && snapshot.data()?['seeded'] == true) {
      return; // already seeded
    }

    // Run seeding inside a transaction for idempotency.
    await _db.runTransaction((txn) async {
      final freshSnap = await txn.get(metaDoc);
      if (freshSnap.exists && freshSnap.data()?['seeded'] == true) {
        return; // another client already seeded
      }

      for (final benefit in _sampleBenefits) {
        final ref = _db.collection('benefits').doc();
        txn.set(ref, benefit);
      }

      txn.set(metaDoc, {'seeded': true});
    });
  }

  static final List<Map<String, dynamic>> _sampleBenefits = [
    {
      'title': 'Airport Lounge Access',
      'description':
          'Enjoy complimentary access to over 1,200 airport lounges worldwide before your flight.',
      'category': 'Travel',
      'terms':
          'Valid for the primary cardholder only. Guest passes may be purchased separately. Lounge access is subject to availability.',
      'isCheckoutEnabled': true,
    },
    {
      'title': 'Cashback on Dining',
      'description':
          'Earn 3% cashback on all dining purchases at restaurants, cafes, and food delivery services.',
      'category': 'Cashback',
      'terms':
          'Cashback is credited to your statement within 2 billing cycles. Maximum cashback of \$50 per month.',
      'isCheckoutEnabled': false,
    },
    {
      'title': 'Extended Warranty',
      'description':
          'Get an extra year of warranty coverage on eligible purchases made with your card.',
      'category': 'Protection',
      'terms':
          'Applies to items with an existing manufacturer warranty of 3 years or less. Claims must be filed within 30 days of product failure.',
      'isCheckoutEnabled': false,
    },
    {
      'title': 'Concert Pre-Sale Tickets',
      'description':
          'Get early access to purchase tickets for popular concerts and live events before the general public.',
      'category': 'Entertainment',
      'terms':
          'Pre-sale availability varies by event. Limited to 4 tickets per event per cardholder.',
      'isCheckoutEnabled': true,
    },
    {
      'title': 'Travel Insurance',
      'description':
          'Complimentary travel insurance covering trip cancellation, lost luggage, and medical emergencies abroad.',
      'category': 'Travel',
      'terms':
          'Coverage activates when the full trip cost is charged to the card. Maximum coverage \$500,000. Pre-existing conditions excluded.',
      'isCheckoutEnabled': false,
    },
    {
      'title': 'Free Streaming Subscription',
      'description':
          'Receive a complimentary 12-month subscription to a premium streaming service of your choice.',
      'category': 'Entertainment',
      'terms':
          'Choose from participating streaming partners. Subscription auto-renews at standard rate after 12 months unless cancelled.',
      'isCheckoutEnabled': true,
    },
    {
      'title': 'Grocery Rewards',
      'description':
          'Earn 5x points on grocery store purchases every month, up to \$500 in spending.',
      'category': 'Cashback',
      'terms':
          'Points apply to purchases at qualifying grocery merchants. Does not include warehouse clubs or supercenters.',
      'isCheckoutEnabled': false,
    },
    {
      'title': 'Roadside Assistance',
      'description':
          'Get 24/7 roadside assistance including towing, flat tire change, jump starts, and lockout service.',
      'category': 'Protection',
      'terms':
          'Up to 4 service calls per year. Towing covered up to 50 miles. Additional mileage charged at standard rates.',
      'isCheckoutEnabled': true,
    },
  ];
}
