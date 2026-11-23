# CRUST FOOD

CRUST FOOD is a Flutter food ordering application. It currently includes a customer-facing menu, product galleries, favorites, cart, checkout, and order-history prototype. Staff tools, Firebase services, persistent storage, and payment processing are not connected yet.

## Phase 1: project foundation

The customer ordering flow runs locally in the app: menu items are priced in PKR, cart totals include delivery, checkout validates delivery details, and placed orders can be viewed, cancelled, or reordered. Cart and order data are kept in memory and reset when the app restarts; connect a backend before using this for real transactions.

## Requirements

- Flutter SDK compatible with the Dart constraint in `pubspec.yaml`
- Android Studio or Xcode for building on a device or simulator

## Create the project from an empty directory

From the project directory, run:

```powershell
flutter create --org com.crustfood --project-name crust_food .
```

Then fetch packages and run the app:

```powershell
flutter pub get
flutter run
```

## Source layout

```text
lib/
  app/                 App root and top-level composition
  core/
    routing/            Route names and navigation configuration
    theme/              Shared colors and Material 3 theme
  features/
    home/presentation/  Current customer landing screen
    authentication/     Planned customer authentication feature
    products/           Planned catalog and product details
    cart/               Planned cart feature
    checkout/           Planned checkout feature
    orders/             Planned order history and tracking
    admin/              Separate planned staff application area
  main.dart             Flutter entry point and ProviderScope
```

Each feature can grow into `data/`, `domain/`, and `presentation/` layers as its behavior is implemented. Shared infrastructure belongs in `core/`; feature-specific rules and data stay inside the owning feature.

## Current setup

- App identifier: `com.crustfood.crust_food`
- State management: Riverpod
- Navigation: GoRouter
- Firebase, maps, payment providers, and production credentials are not configured in Phase 1.

The admin routes are only route placeholders at this stage. Role checks and Firebase Security Rules are required before any real staff functionality is exposed; those are planned for later phases.

## Configuration

See `.env.example` for the configuration names planned for later phases. Do not put private server credentials, payment secrets, or service account keys in a Flutter bundle or commit them to source control. Public mobile API keys must be restricted by app identifier and API in the provider console.

## Next phases

Continue with Firebase setup, authentication, the customer catalog and ordering experience, then staff tools, authorization rules, and deployment configuration. No production backend is connected yet.
