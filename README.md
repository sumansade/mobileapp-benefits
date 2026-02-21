# Benefits MVP

A Flutter mobile app (Material 3) demonstrating card-linked benefits with Firebase Authentication and Cloud Firestore.

## Features

- **Email/password authentication** via Firebase Auth
- **Dummy card registration** — collects card number, expiry, CVV at sign-up; stores only last 4 digits, expiry, and inferred brand (VISA/MC/AMEX/DISCOVER/OTHER). **CVV is never persisted.**
- **Auth gate** — routes unauthenticated users to Welcome screen, authenticated users to Home
- **Home screen** — masked card summary (`BRAND •••• LAST4`) + scrollable benefits list from Firestore
- **Benefit detail** — full description, terms, and checkout button (when enabled)
- **Dummy checkout** — creates an `orders` document in Firestore with status `CONFIRMED`
- **Auto-seed** — on first launch, seeds 8 sample benefits into Firestore (idempotent via `_meta/seed`)

## Architecture

```
lib/
├── main.dart              # App entry point, Firebase init, Material 3 theme
├── router.dart            # go_router config with auth-gate redirect
├── screens/
│   ├── welcome_screen.dart
│   ├── register_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── benefit_detail_screen.dart
│   ├── checkout_screen.dart
│   └── confirmation_screen.dart
├── services/
│   ├── auth_service.dart       # Firebase Auth wrapper
│   ├── firestore_service.dart  # Firestore CRUD for users, benefits, orders
│   └── seed_service.dart       # First-run benefit seeding
└── utils/
    ├── validators.dart    # Form field validators
    └── card_utils.dart    # Card brand inference, last-4 extraction, masked display
```

## Firestore Collections

| Collection | Key Fields |
|---|---|
| `users/{uid}` | `email`, `cardLast4`, `cardExpiry`, `cardBrand`, `createdAt` |
| `benefits/{benefitId}` | `title`, `description`, `category`, `terms`, `isCheckoutEnabled` |
| `orders/{orderId}` | `uid`, `benefitId`, `status`, `createdAt` |
| `_meta/seed` | `seeded` (boolean) |

## Setup

### Prerequisites

- Flutter SDK (stable channel)
- Firebase project with **Authentication** (Email/Password enabled) and **Cloud Firestore** enabled
- FlutterFire CLI (optional but recommended)

### 1. Configure Firebase

Option A — FlutterFire CLI (recommended):

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_PROJECT_ID
```

This generates `lib/firebase_options.dart`. Then update `lib/main.dart`:

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

Option B — Manual:

1. Add your `google-services.json` (Android) to `android/app/`
2. Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`

### 2. Enable Firebase Services

In the [Firebase Console](https://console.firebase.google.com):

1. **Authentication** → Sign-in method → Enable **Email/Password**
2. **Firestore Database** → Create database (start in test mode or paste rules from `docs/firestore_rules.md`)

### 3. Deploy Firestore Rules

Copy the rules from [`docs/firestore_rules.md`](docs/firestore_rules.md) into your Firestore Rules editor.

## Run

```bash
flutter pub get
flutter run
```

## Changing Benefits

Benefits are auto-seeded on first launch from `lib/services/seed_service.dart`. To modify:

1. Edit the `_sampleBenefits` list in `seed_service.dart`
2. Delete the `_meta/seed` document in Firestore to re-trigger seeding
3. Optionally delete existing `benefits` documents for a clean slate

For production, manage benefits via the Firebase Console or an admin panel instead of client-side seeding.

## Security Notes

- **CVV is never stored** — only `cardLast4`, `cardExpiry`, and `cardBrand` are persisted
- This is an **MVP with dummy card input** — do not use for real payments
- See `docs/firestore_rules.md` for security rules and production hardening notes
