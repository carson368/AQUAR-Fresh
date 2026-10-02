# KIU Fresh

KIU Fresh is a Flutter MVP for a water-refilling ordering and delivery platform.

## Current MVP
- Customer, delivery, and administrator demo roles
- Product catalogue
- Checkout and local order creation
- Simulated M-Pesa/cash choice
- Customer order tracking
- Delivery status workflow
- Admin operational dashboard
- Local in-memory mock store

## Important
Authentication, M-Pesa, persistence, notifications, and backend authorization are **simulated/not production-ready** in this build. The next commercial milestone is a real backend, persistent database, secure authentication, and server-verified M-Pesa integration.

## Run
```bash
flutter pub get
flutter run
```

On the demo login screen, enter any non-empty phone/email and password, then choose Customer, Delivery, or Admin.
