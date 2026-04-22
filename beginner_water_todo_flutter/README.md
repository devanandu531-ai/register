# Beginner Water + To-Do Flutter App

This is a beginner-friendly Flutter app with:

- Water tracking (daily count, auto-reset by date)
- To-do list (add, complete, delete)
- Local storage with SharedPreferences
- Local notifications:
  - Hourly water reminder
  - Optional task reminder using selected time

## 1) Project structure

```text
beginner_water_todo_flutter/
├─ lib/
│  ├─ main.dart
│  ├─ models.dart
│  ├─ screens/
│  │  ├─ dashboard_screen.dart
│  │  └─ tasks_screen.dart
│  └─ services/
│     ├─ notification_service.dart
│     └─ storage_service.dart
├─ pubspec.yaml
└─ README.md
```

## 2) Setup (step-by-step)

1. Install Flutter from: https://docs.flutter.dev/get-started/install
2. Create a new project:

   ```bash
   flutter create beginner_water_todo_flutter
   ```

3. Replace `pubspec.yaml` and `lib/` files with the files in this folder.
4. Install dependencies:

   ```bash
   flutter pub get
   ```

5. Run app:

   ```bash
   flutter run
   ```

## Android notification notes

For notifications, make sure your Android app has notification permission (Android 13+).

In `android/app/src/main/AndroidManifest.xml`, include:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

## 3) What each part does

- `main.dart`: starts app and initializes notification system.
- `storage_service.dart`: saves/loads water count and tasks in local storage.
- `notification_service.dart`: handles recurring water reminders and task reminders.
- `dashboard_screen.dart`: shows water progress and a button to log one glass.
- `tasks_screen.dart`: add/check/delete tasks and set reminder times.
- `models.dart`: simple `TodoTask` model + JSON encode/decode helpers.

## 4) Beginner tips

- Keep features in separate files (screens/services/models) so code is easier to read.
- Build one feature at a time and test often.
- Add comments only where logic is not obvious.
