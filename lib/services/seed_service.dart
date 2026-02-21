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
      'subtitle': 'Relax before your flight in style',
      'description':
          'Enjoy complimentary access to over 1,200 airport lounges worldwide. Unwind with premium refreshments, Wi-Fi, and comfortable seating before your flight.',
      'category': 'Travel',
      'imageUrl': 'https://images.unsplash.com/photo-1540339832862-474599807836?w=800&h=450&fit=crop',
      'terms': 'Valid for the primary cardholder only. Guest passes may be purchased separately. Lounge access is subject to availability.',
      'isCheckoutEnabled': true,
      'ctaText': 'Enroll Now',
      'redemptionType': 'enroll',
      'valueProps': [
        'Access 1,200+ lounges in 140+ countries',
        'Complimentary food, drinks & Wi-Fi',
        'Quiet workspace & shower facilities',
        'Priority Pass membership included',
      ],
      'howToRedeem': [
        'Tap "Enroll Now" to activate your lounge benefit',
        'Download the Priority Pass app',
        'Show your digital membership at any participating lounge',
        'Enjoy unlimited visits throughout the year',
      ],
      'eligibility': 'Available to all Visa Infinite cardholders',
      'faq': [
        {'q': 'Can I bring a guest?', 'a': 'Guest passes are available for \$35 per visit.'},
        {'q': 'How many visits per year?', 'a': 'Unlimited visits for the primary cardholder.'},
      ],
    },
    {
      'title': 'Fine Dining Collection',
      'subtitle': 'Exclusive culinary experiences',
      'description':
          'Access a curated collection of fine dining experiences with complimentary courses, wine pairings, and priority reservations at Michelin-starred restaurants.',
      'category': 'Dining',
      'imageUrl': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&h=450&fit=crop',
      'terms': 'Available at participating restaurants. Reservation required 48 hours in advance. Subject to availability.',
      'isCheckoutEnabled': true,
      'ctaText': 'Reserve Now',
      'redemptionType': 'enroll',
      'valueProps': [
        'Complimentary course at 50+ top restaurants',
        'Priority reservations & VIP seating',
        'Exclusive wine pairing experiences',
        'Personal concierge for special occasions',
      ],
      'howToRedeem': [
        'Browse participating restaurants in the app',
        'Select your preferred date and party size',
        'Confirm your reservation with your Visa card',
        'Present your confirmation at the restaurant',
      ],
      'eligibility': 'Available to Visa Signature and Visa Infinite cardholders',
      'faq': [
        {'q': 'Is there a limit on visits?', 'a': 'You may visit each restaurant once per quarter.'},
        {'q': 'Can I cancel?', 'a': 'Free cancellation up to 24 hours before the reservation.'},
      ],
    },
    {
      'title': 'Purchase Protection',
      'subtitle': 'Your purchases, fully covered',
      'description':
          'Get comprehensive protection on eligible purchases. Coverage against damage, theft, and defects for 120 days from the purchase date.',
      'category': 'Protection',
      'imageUrl': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=450&fit=crop',
      'terms': 'Coverage up to \$10,000 per claim. Maximum \$50,000 per year. Pre-existing damage excluded.',
      'isCheckoutEnabled': false,
      'ctaText': 'Learn More',
      'redemptionType': 'enroll',
      'valueProps': [
        'Coverage for damage, theft & defects',
        '120-day protection from purchase date',
        'Up to \$10,000 per claim',
        'Easy online claims process',
      ],
      'howToRedeem': [
        'Make your purchase with your Visa card',
        'If an issue occurs, file a claim online',
        'Submit photos and receipt documentation',
        'Receive reimbursement within 5 business days',
      ],
      'eligibility': 'Automatic for all purchases made with your Visa card',
      'faq': [
        {'q': 'What items are covered?', 'a': 'Most personal items. Excludes vehicles, real estate, and perishables.'},
        {'q': 'How do I file a claim?', 'a': 'Visit the claims portal or call our 24/7 support line.'},
      ],
    },
    {
      'title': 'Concert & Event Pre-Sale',
      'subtitle': 'First access to the hottest tickets',
      'description':
          'Get exclusive early access to purchase tickets for concerts, theater, sports events, and live experiences before the general public.',
      'category': 'Entertainment',
      'imageUrl': 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&h=450&fit=crop',
      'terms': 'Pre-sale availability varies by event. Limited to 4 tickets per event per cardholder.',
      'isCheckoutEnabled': true,
      'ctaText': 'Browse Events',
      'redemptionType': 'purchase',
      'valueProps': [
        '48-hour early access to tickets',
        'Premium seat selection priority',
        'VIP meet & greet packages available',
        'Exclusive Visa-only events',
      ],
      'howToRedeem': [
        'Check the Events section for upcoming pre-sales',
        'Select your event and preferred seats',
        'Complete purchase with your Visa card',
        'Receive e-tickets directly to your device',
      ],
      'eligibility': 'Available to all Visa cardholders',
      'faq': [
        {'q': 'How early is the pre-sale?', 'a': 'Typically 48 hours before general sale.'},
        {'q': 'Are there VIP packages?', 'a': 'Yes, select events offer meet & greet and backstage access.'},
      ],
    },
    {
      'title': 'Travel Insurance Premium',
      'subtitle': 'Travel with complete peace of mind',
      'description':
          'Comprehensive travel insurance covering trip cancellation, lost luggage, medical emergencies abroad, and flight delays.',
      'category': 'Travel',
      'imageUrl': 'https://images.unsplash.com/photo-1436491865332-7a61a109db05?w=800&h=450&fit=crop',
      'terms': 'Coverage activates when the full trip cost is charged to the card. Maximum coverage \$500,000.',
      'isCheckoutEnabled': false,
      'ctaText': 'View Coverage',
      'redemptionType': 'enroll',
      'valueProps': [
        'Trip cancellation up to \$10,000',
        'Medical emergency coverage up to \$500,000',
        'Lost luggage reimbursement up to \$3,000',
        'Flight delay compensation (3+ hours)',
      ],
      'howToRedeem': [
        'Book your trip using your Visa card',
        'Coverage activates automatically',
        'If you need to file a claim, visit the claims portal',
        'Provide trip details and supporting documentation',
      ],
      'eligibility': 'Automatic when trip is charged to your Visa Infinite card',
      'faq': [
        {'q': 'Is family covered?', 'a': 'Yes, immediate family members traveling with you are covered.'},
        {'q': 'What about pre-existing conditions?', 'a': 'Standard pre-existing condition exclusions apply.'},
      ],
    },
    {
      'title': 'Streaming & Digital',
      'subtitle': 'Premium entertainment, on us',
      'description':
          'Receive a complimentary 12-month subscription to a premium streaming service of your choice, plus monthly digital credits.',
      'category': 'Entertainment',
      'imageUrl': 'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=800&h=450&fit=crop',
      'terms': 'Choose from participating streaming partners. Auto-renews at standard rate after 12 months unless cancelled.',
      'isCheckoutEnabled': true,
      'ctaText': 'Activate Now',
      'redemptionType': 'voucher',
      'valueProps': [
        'Choose from 5+ premium streaming services',
        '12 months of free premium access',
        '\$10/month digital credit for books & music',
        'Family plan upgrades available',
      ],
      'howToRedeem': [
        'Select your preferred streaming service',
        'Link your Visa card to your streaming account',
        'Your subscription activates immediately',
        'Digital credits are applied monthly',
      ],
      'eligibility': 'Available to Visa Signature and Visa Infinite cardholders',
      'faq': [
        {'q': 'Can I switch services?', 'a': 'You can switch once after the first 3 months.'},
        {'q': 'What happens after 12 months?', 'a': 'Continues at standard rate unless you cancel.'},
      ],
    },
    {
      'title': 'Luxury Hotel Collection',
      'subtitle': 'Elevated stays at world-class properties',
      'description':
          'Enjoy automatic room upgrades, late checkout, complimentary breakfast, and exclusive amenities at 900+ luxury hotels worldwide.',
      'category': 'Lifestyle',
      'imageUrl': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=450&fit=crop',
      'terms': 'Benefits subject to availability at check-in. Must book through the Visa Luxury Hotel Collection portal. Minimum 2-night stay.',
      'isCheckoutEnabled': true,
      'ctaText': 'Book a Stay',
      'redemptionType': 'purchase',
      'valueProps': [
        'Automatic room upgrade at check-in',
        'Daily complimentary breakfast for two',
        'Late checkout (4 PM when available)',
        '\$100 hotel credit per stay',
      ],
      'howToRedeem': [
        'Browse hotels in the Luxury Collection',
        'Book your stay for 2+ nights',
        'Pay with your Visa Infinite card',
        'Benefits are applied automatically at check-in',
      ],
      'eligibility': 'Exclusive to Visa Infinite cardholders',
      'faq': [
        {'q': 'Is the upgrade guaranteed?', 'a': 'Upgrades are subject to availability at check-in.'},
        {'q': 'Can I combine with hotel loyalty?', 'a': 'Yes, you can earn loyalty points alongside Visa benefits.'},
      ],
    },
    {
      'title': 'Grocery & Essentials Rewards',
      'subtitle': 'Earn more on everyday spending',
      'description':
          'Earn 5X points on grocery store purchases every month, up to \$500 in spending. Plus, exclusive cashback offers at select retailers.',
      'category': 'Lifestyle',
      'imageUrl': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&h=450&fit=crop',
      'terms': 'Points apply to purchases at qualifying grocery merchants. Does not include warehouse clubs or supercenters.',
      'isCheckoutEnabled': false,
      'ctaText': 'View Offers',
      'redemptionType': 'credit',
      'valueProps': [
        '5X points at grocery stores (up to \$500/mo)',
        'Rotating 10% cashback at select retailers',
        'Automatic statement credits',
        'No enrollment required',
      ],
      'howToRedeem': [
        'Simply use your Visa card at qualifying stores',
        'Points are earned automatically',
        'Redeem points as statement credits or gift cards',
        'Check the app for rotating bonus offers',
      ],
      'eligibility': 'Available to all Visa cardholders',
      'faq': [
        {'q': 'Do warehouse clubs count?', 'a': 'No, warehouse clubs and supercenters are excluded.'},
        {'q': 'When do points post?', 'a': 'Points appear within 1-2 billing cycles.'},
      ],
    },
    {
      'title': 'Roadside Assistance 24/7',
      'subtitle': 'Help is always a call away',
      'description':
          'Get 24/7 roadside assistance including towing, flat tire change, jump starts, lockout service, and fuel delivery.',
      'category': 'Protection',
      'imageUrl': 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800&h=450&fit=crop',
      'terms': 'Up to 4 service calls per year. Towing covered up to 50 miles. Additional mileage at standard rates.',
      'isCheckoutEnabled': true,
      'ctaText': 'Enroll Free',
      'redemptionType': 'enroll',
      'valueProps': [
        '24/7 nationwide coverage',
        'Towing up to 50 miles included',
        'Flat tire, jump start & lockout service',
        'Fuel delivery in emergencies',
      ],
      'howToRedeem': [
        'Tap "Enroll Free" to activate your coverage',
        'Save the 24/7 hotline number to your phone',
        'Call anytime you need roadside assistance',
        'Service dispatched within 30 minutes',
      ],
      'eligibility': 'Available to Visa Signature and Visa Infinite cardholders',
      'faq': [
        {'q': 'How many calls per year?', 'a': 'Up to 4 service calls per membership year.'},
        {'q': 'Is this available outside the US?', 'a': 'Currently available in the continental US only.'},
      ],
    },
    {
      'title': 'Wellness & Spa Credit',
      'subtitle': 'Invest in your wellbeing',
      'description':
          'Enjoy a quarterly \$75 wellness credit toward spa treatments, fitness memberships, meditation apps, and health services.',
      'category': 'Lifestyle',
      'imageUrl': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800&h=450&fit=crop',
      'terms': 'Credit of \$75 per quarter. Must be used within the quarter. Cannot be combined with other offers.',
      'isCheckoutEnabled': true,
      'ctaText': 'Redeem Credit',
      'redemptionType': 'voucher',
      'valueProps': [
        '\$75 quarterly wellness credit',
        'Valid at 500+ spa & fitness partners',
        'Includes meditation & therapy apps',
        'Auto-renews each quarter',
      ],
      'howToRedeem': [
        'Browse participating wellness partners',
        'Select your preferred service or membership',
        'Apply your \$75 credit at checkout',
        'Enjoy your wellness experience',
      ],
      'eligibility': 'Available to Visa Infinite cardholders',
      'faq': [
        {'q': 'Can I rollover unused credit?', 'a': 'No, credits expire at the end of each quarter.'},
        {'q': 'What counts as wellness?', 'a': 'Spa, gym, yoga, meditation apps, and health screenings.'},
      ],
    },
  ];
}
