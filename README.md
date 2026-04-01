# Azulon Catalog App

Flutter catalog application for the Azulon assignment.

## Features

- Fetches items from:
  - `https://azulonstudio.github.io/azulon-flutter-test-api/api/items.json`
- Displays loading, error, empty, and success states.
- Catalog screen with responsive grid layout.
- Item detail screen with hero image transition.
- Favorite/unfavorite from catalog and details.
- Favorites persisted locally.
- Product images sourced from Picsum (`https://picsum.photos/`) using deterministic seeds per item id.

## Architecture

Feature-first, lightweight layered structure:

- `data`: DTOs, remote/local sources, repository implementations
- `domain`: entities + repository contracts
- `application`: Riverpod state and controller
- `presentation`: screens and UI widgets

Key goals:

- Keep UI/business/data concerns separated
- Support replacing favorites persistence backend without touching UI
- Keep parsing and network handling isolated and test-adaptable

## Tech

- `flutter_riverpod` for state management and dependency injection
- `dio` for networking (10s timeout + retry policy)
- `shared_preferences` for local favorites persistence

## Run

```bash
flutter pub get
flutter run
```

## Notes

- Network parse is applied only for HTTP status codes in `[200, 300)`.
- Retry policy: 2 retries for retryable failures.
- Tests are intentionally deferred in this phase, but code is structured with interfaces and injectable dependencies for easy testing.
