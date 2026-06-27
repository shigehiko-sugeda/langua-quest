# Langua Quest

Langua Quest is a free, offline-first Flutter vocabulary app for an 11-year-old Japanese child learning beginner English and Korean.

## Features

- Japanese UI with bright, child-friendly screens and large buttons.
- English and Korean course selection.
- 10 words per lesson from local JSON vocabulary files.
- Word cards with Japanese meaning, target word, pronunciation guide, and example sentence.
- Device text-to-speech listen button when TTS is available.
- Multiple-choice quizzes in both directions.
- Mistake review queue; missed words are cleared after 2 correct review answers.
- Local-only progress persistence: completed lessons, streak, missed words, and learned count.
- No ads, no subscription, no login, and no app network calls.

## Project structure

```text
assets/vocab/en.json    # 100 child-friendly English starter words
assets/vocab/ko.json    # 100 child-friendly Korean starter words
lib/models/             # Vocabulary and progress models
lib/services/           # Local storage, vocabulary loading, quiz/progress logic, TTS wrapper
lib/screens/            # Home, lesson, quiz, and review screens
lib/main.dart           # App entry point and theme
```

## Setup

1. Install Flutter from <https://docs.flutter.dev/get-started/install>.
2. Check your environment:

   ```bash
   flutter doctor
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

## Run

```bash
flutter run
```

## Test

```bash
flutter test
```

The included tests cover quiz option generation and progress/mistake-review logic.

## Build

Android:

```bash
flutter build apk --release
```

iOS (on macOS with Xcode):

```bash
flutter build ios --release
```

## Offline and privacy notes

All vocabulary is bundled in `assets/vocab/*.json`, and progress is stored with `shared_preferences` on the device. The app does not require login, analytics, ads, subscriptions, or external network access.
