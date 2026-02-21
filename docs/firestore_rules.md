# Firestore Security Rules

Copy these rules into your Firebase Console under **Firestore Database > Rules**.

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // ───── Users ─────
    // Only the authenticated user can read/write their own profile.
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }

    // ───── Benefits ─────
    // Any authenticated user can read benefits.
    // Writes are disabled for clients (MVP only – seed from server/admin SDK).
    // NOTE: For the auto-seed feature to work from the client during MVP,
    // you may temporarily allow writes. Tighten this before production.
    match /benefits/{benefitId} {
      allow read: if request.auth != null;
      // MVP: allow create for seeding from client. Remove for production.
      allow create: if request.auth != null;
      allow update, delete: if false;
    }

    // ───── Orders ─────
    // Users can only create and read their own orders. No update/delete.
    match /orders/{orderId} {
      allow create: if request.auth != null
                    && request.resource.data.uid == request.auth.uid;
      allow read:   if request.auth != null
                    && resource.data.uid == request.auth.uid;
      allow update, delete: if false;
    }

    // ───── _meta ─────
    // Permissive for MVP seeding. Tighten for production:
    //   - Allow read for all auth users, write only from admin/server SDK.
    match /_meta/{docId} {
      allow read, write: if request.auth != null;
    }

    // Deny everything else by default.
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## Production Hardening Notes

1. **Benefits writes**: Remove the `allow create` rule on `/benefits/{benefitId}`. Seed benefits via the Firebase Admin SDK or the Firebase Console instead of from the client.
2. **`_meta` writes**: Lock down to admin-only writes so clients cannot tamper with the seed flag.
3. **Orders**: Consider adding validation rules (e.g., `request.resource.data.status == 'CONFIRMED'`) to ensure clients cannot set arbitrary statuses.
4. **Rate limiting**: Firestore rules don't support rate limiting natively. Use Cloud Functions or App Check for abuse prevention.
