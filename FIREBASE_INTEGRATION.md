# Firebase Analytics & Crashlytics Integration

## Overview
This document describes the Firebase Analytics and Crashlytics integration for the Ditonton Android app. The integration allows developers to track user behavior and monitor app stability through crash reporting.

## Features Implemented

### 1. Firebase Analytics
Firebase Analytics has been integrated to track the following events:

- **Screen Navigation**: Automatically tracks all screen views using `FirebaseAnalyticsObserver`
- **Movie Views**: Tracks when users view movie details
  - Event: `view_movie_detail`
  - Parameters: `movie_id`, `movie_title`
- **Watchlist Actions**: Tracks when users add/remove items from watchlist
  - Event: `add_to_watchlist` / `remove_from_watchlist`
  - Parameters: `item_id`, `item_type`, `item_title`
- **Button Clicks**: Tracks specific button interactions
  - Event: `button_click`
  - Parameters: `button_name`, `screen_name`

### 2. Firebase Crashlytics
Firebase Crashlytics has been configured to:

- Automatically capture all uncaught Flutter errors
- Report fatal errors from the Flutter framework
- Capture asynchronous errors not handled by Flutter
- Support manual error reporting via `AnalyticsService`
- Include a test crash button in the About page for verification

## Files Modified

### Configuration Files
1. **pubspec.yaml**
   - Added `firebase_analytics: ^11.3.3`
   - Added `firebase_crashlytics: ^4.1.3`

2. **android/settings.gradle**
   - Added Crashlytics plugin: `id "com.google.firebase.crashlytics" version "2.9.9"`

3. **android/app/build.gradle**
   - Applied Crashlytics plugin: `id 'com.google.firebase.crashlytics'`

### Dart Files
1. **lib/main.dart**
   - Initialized Firebase in main()
   - Set up global error handlers for Crashlytics
   - Added `FirebaseAnalyticsObserver` for screen tracking

2. **lib/common/analytics_service.dart** (New File)
   - Created singleton service for analytics and crashlytics
   - Provides methods for logging custom events
   - Includes crash testing functionality

3. **lib/presentation/pages/movie_detail_page.dart**
   - Added analytics tracking for movie views
   - Added analytics tracking for watchlist operations

4. **lib/presentation/pages/about_page.dart**
   - Added "Test Crashlytics" button for testing crash reporting

## Setup Instructions

### Prerequisites
- Ensure you have `google-services.json` in `android/app/` directory
- Firebase project must be configured with Analytics and Crashlytics enabled

### Installation Steps

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Build the app for Android**
   ```bash
   flutter build apk --release
   # or for debug
   flutter build apk --debug
   ```

3. **Run the app on Android device**
   ```bash
   flutter run
   ```

## Testing Instructions

### Testing Analytics

1. **Run the app on a real Android device or emulator**
2. **Perform the following actions:**
   - Navigate to different screens (Home, Search, Watchlist, etc.)
   - View movie details by tapping on a movie
   - Add/remove movies from watchlist
   - Navigate to the About page

3. **View Analytics Data:**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Select your project
   - Navigate to **Analytics > Events**
   - You should see events like:
     - `screen_view`
     - `view_movie_detail`
     - `add_to_watchlist`
     - `remove_from_watchlist`
     - `button_click`

   **Note:** Analytics data may take up to 24 hours to appear in the dashboard. For real-time debugging, use **DebugView**:
   ```bash
   adb shell setprop debug.firebase.analytics.app id.my.teoprayogak.dinonton
   ```
   Then go to **Analytics > DebugView** in Firebase Console.

### Testing Crashlytics

1. **Run the app on a real Android device**
2. **Trigger a test crash:**
   - Navigate to the About page from the drawer menu
   - Tap the **"Test Crashlytics"** button (red button)
   - The app will crash immediately

3. **View Crash Reports:**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Select your project
   - Navigate to **Crashlytics**
   - You should see the crash report within a few minutes
   - Click on the crash to see the stack trace and details

   **Note:** Crashlytics reports appear faster than Analytics (usually within 5 minutes for release builds, immediately for debug builds with symbolication).

## Viewing Firebase Dashboards

### Analytics Dashboard

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Analytics** section
4. Available views:
   - **Dashboard**: Overview of user engagement
   - **Events**: List of all tracked events
   - **Conversions**: Track important user actions
   - **Audiences**: Segment users based on behavior
   - **DebugView**: Real-time event debugging

### Crashlytics Dashboard

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Crashlytics** section
4. Available views:
   - **Dashboard**: Overview of crashes and stability
   - **Issues**: List of all crash types grouped by similarity
   - **Velocity alerts**: Notifications for spike in crashes
   - **Stack traces**: Detailed crash information

## Screenshots

To generate screenshots for documentation:

1. **Analytics Dashboard:**
   - Open Firebase Console > Analytics > Events
   - Take screenshot showing the events list
   - Take screenshot showing event details (e.g., `view_movie_detail`)

2. **Crashlytics Dashboard:**
   - Open Firebase Console > Crashlytics
   - Take screenshot showing the crashes overview
   - Take screenshot showing a crash detail with stack trace

3. **DebugView (Optional):**
   - Enable DebugView using adb command
   - Open Firebase Console > Analytics > DebugView
   - Interact with the app
   - Take screenshot showing real-time events

## Analytics Service API

The `AnalyticsService` singleton provides the following methods:

```dart
// Analytics Events
await AnalyticsService().logMovieView(movieId, movieTitle);
await AnalyticsService().logTvSeriesView(tvSeriesId, tvSeriesTitle);
await AnalyticsService().logSearch(searchTerm, searchType);
await AnalyticsService().logAddToWatchlist(itemId, itemType, itemTitle);
await AnalyticsService().logRemoveFromWatchlist(itemId, itemType, itemTitle);
await AnalyticsService().logScreenView(screenName);
await AnalyticsService().logButtonClick(buttonName, screenName);

// Crashlytics Methods
AnalyticsService().setUserIdentifier(userId);
AnalyticsService().setCustomKey(key, value);
await AnalyticsService().recordError(exception, stack, reason: reason, fatal: false);
await AnalyticsService().log(message);
await AnalyticsService().testCrash(); // Only for testing
```

## Platform Support

- **Android**: ✅ Fully supported
- **iOS**: ❌ Not configured (Android only as per requirements)

## Troubleshooting

### Analytics not showing data
- Enable DebugView for real-time testing
- Check that `google-services.json` is properly configured
- Ensure internet connection is available
- Wait up to 24 hours for data to appear in standard reports

### Crashlytics not reporting crashes
- Ensure you're testing on a real device (not all emulators support it)
- Check that Crashlytics is enabled in Firebase Console
- For debug builds, ensure symbolication files are uploaded
- Restart the app after a crash to send the report

### Build errors
- Run `flutter clean` and `flutter pub get`
- Check that all Gradle plugin versions are compatible
- Ensure Android SDK is up to date

## Additional Resources

- [Firebase Analytics Documentation](https://firebase.google.com/docs/analytics)
- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
