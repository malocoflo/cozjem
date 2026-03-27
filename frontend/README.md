# CoZjem Frontend

Flutter mobile application for the CoZjem AI-powered fridge scanner and recipe assistant.

## Requirements

- Flutter SDK 3.22+
- Dart 3.3+
- Android SDK / Xcode (for device builds)
- A running CoZjem backend at `http://localhost:8000`

## Setup

```bash
cd frontend
flutter pub get
```

## Configuration

By default the app connects to `http://localhost:8000`. To change the backend URL, pass it as a compile-time constant:

```bash
flutter run --dart-define=API_BASE_URL=https://your-backend.com
```

## Running

```bash
# Debug mode on connected device / emulator
flutter run

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart           # Entry point
├── app.dart            # MaterialApp + routing
├── theme/
│   └── app_theme.dart  # Design system (colors, typography)
├── screens/
│   ├── home_screen.dart        # Camera scan screen
│   ├── ingredients_screen.dart # Ingredient confirmation
│   └── recipes_screen.dart     # Recipe results
├── widgets/
│   ├── glassmorphism_app_bar.dart
│   ├── scanner_card.dart
│   ├── recipe_card.dart
│   ├── ingredient_tile.dart
│   ├── ingredient_floating_plate.dart
│   ├── filter_chip_bar.dart
│   └── bottom_nav_bar.dart
├── services/
│   ├── camera_service.dart   # Camera integration
│   └── api_service.dart      # HTTP client
└── models/
    ├── ingredient.dart
    └── recipe.dart
web/
└── camera.ts    # TypeScript camera utility for web
```

## Screens

1. **Home Screen** — Camera scanner with quick recipe carousel
2. **Ingredients Screen** — Review and edit AI-detected ingredients
3. **Recipes Screen** — Browse matched recipes with filter chips

## API Flow

```
Home → [scan/gallery] → API POST /api/analyze-fridge → Ingredients → Recipes
```
