# Firebase Mock Helper for Testing

## Overview
This helper provides Firebase mocking functionality for unit and widget tests, preventing the common error:
```
No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
```

## Files
- **firebase_mock_helper.dart**: Main helper file with Firebase mocking functions

## Usage

### Basic Setup

Import the helper in your test file:
```dart
import '../../helpers/firebase_mock_helper.dart';
```

### In setUpAll()
Call `setupFirebaseMocks()` once before all tests:
```dart
setUpAll(() {
  setupFirebaseMocks();
});
```

### In tearDownAll()
Clean up Firebase mocks after all tests:
```dart
tearDownAll(() {
  clearFirebaseMocks();
});
```

### Complete Example

```dart
import 'package:ditonton/common/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/firebase_mock_helper.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}
class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late MockFirebaseCrashlytics mockCrashlytics;

  setUpAll(() {
    // Setup Firebase platform mocks
    setupFirebaseMocks();
  });

  setUp(() {
    // Create mocks
    mockAnalytics = MockFirebaseAnalytics();
    mockCrashlytics = MockFirebaseCrashlytics();

    // Configure AnalyticsService with mocks
    AnalyticsService.resetInstance();
    AnalyticsService(
      analytics: mockAnalytics,
      crashlytics: mockCrashlytics,
    );

    // Stub methods
    when(() => mockAnalytics.logEvent(
      name: any(named: 'name'),
      parameters: any(named: 'parameters'),
    )).thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    AnalyticsService.resetInstance();
  });

  tearDownAll(() {
    clearFirebaseMocks();
  });

  test('your test here', () {
    // Your test code
  });
}
```

## What Gets Mocked

### Firebase Core
- `Firebase#initializeCore`
- `Firebase#initializeApp`

### Firebase Analytics
- `Analytics#logEvent`
- `Analytics#setUserId`
- `Analytics#setUserProperty`
- `Analytics#setCurrentScreen`
- `Analytics#setAnalyticsCollectionEnabled`

### Firebase Crashlytics
- `Crashlytics#checkForUnsentReports`
- `Crashlytics#deleteUnsentReports`
- `Crashlytics#didCrashOnPreviousExecution`
- `Crashlytics#setCrashlyticsCollectionEnabled`
- `Crashlytics#sendUnsentReports`
- `Crashlytics#log`
- `Crashlytics#setCustomKey`
- `Crashlytics#setUserIdentifier`
- `Crashlytics#recordError`
- `Crashlytics#crash`

## Updated Test Files

The following test files have been updated to use Firebase mocks:

1. **test/presentation/pages/movie_detail_page_test.dart**
   - Added Firebase mock setup
   - Added AnalyticsService mock configuration
   - Tests watchlist button analytics tracking

2. **test/presentation/pages/about_page_test.dart**
   - Added Firebase mock setup
   - Added AnalyticsService mock configuration
   - Added test for "Test Crashlytics" button
   - Verifies analytics and crashlytics calls

## Common Patterns

### Pattern 1: Testing Analytics Events

```dart
testWidgets('should log analytics event when button tapped', (tester) async {
  // Arrange
  when(() => mockAnalytics.logEvent(
    name: any(named: 'name'),
    parameters: any(named: 'parameters'),
  )).thenAnswer((_) async => Future.value());

  // Act
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();

  // Assert
  verify(() => mockAnalytics.logEvent(
    name: 'button_click',
    parameters: {'button_name': 'test'},
  )).called(1);
});
```

### Pattern 2: Testing Crashlytics

```dart
testWidgets('should trigger crash when crash button tapped', (tester) async {
  // Arrange
  when(() => mockCrashlytics.crash()).thenAnswer((_) async => Future.value());

  // Act
  await tester.tap(find.text('Test Crash'));
  await tester.pump();

  // Assert
  verify(() => mockCrashlytics.crash()).called(1);
});
```

### Pattern 3: Testing with AnalyticsService Singleton

```dart
setUp(() {
  // Reset singleton before each test
  AnalyticsService.resetInstance();

  // Configure with mocks
  AnalyticsService(
    analytics: mockAnalytics,
    crashlytics: mockCrashlytics,
  );
});

tearDown(() {
  // Clean up after each test
  AnalyticsService.resetInstance();
});
```

## Why This Approach?

### Problem
When testing widgets/pages that use Firebase services (Analytics, Crashlytics), tests fail with:
```
No Firebase App '[DEFAULT]' has been created
```

This happens because:
1. Firebase requires initialization before use
2. We can't actually initialize Firebase in unit/widget tests
3. Firebase services use platform channels that aren't available in tests

### Solution
The `firebase_mock_helper.dart` provides:
1. **Platform Channel Mocking**: Mocks the MethodChannel responses
2. **Fake Firebase Instance**: Returns fake data for Firebase initialization
3. **No-op Responses**: All Firebase method calls return null/empty responses
4. **Easy Cleanup**: Simple functions to set up and tear down mocks

### Benefits
- ✅ Tests run without actual Firebase initialization
- ✅ No network calls during testing
- ✅ Fast test execution
- ✅ Predictable test behavior
- ✅ Easy to verify Firebase interactions using Mocktail

## Troubleshooting

### Error: MissingPluginException
**Cause**: Firebase mocks not set up before widget is built.

**Solution**: Call `setupFirebaseMocks()` in `setUpAll()`:
```dart
setUpAll(() {
  setupFirebaseMocks();
});
```

### Error: Bad state: No method stub was called
**Cause**: Trying to verify a method that wasn't stubbed.

**Solution**: Add stub in `setUp()`:
```dart
setUp(() {
  when(() => mockAnalytics.logEvent(
    name: any(named: 'name'),
    parameters: any(named: 'parameters'),
  )).thenAnswer((_) async => Future.value());
});
```

### Error: The singleton is already configured
**Cause**: AnalyticsService wasn't reset between tests.

**Solution**: Reset in `setUp()` and `tearDown()`:
```dart
setUp(() {
  AnalyticsService.resetInstance();
  // ... configure
});

tearDown() {
  AnalyticsService.resetInstance();
});
```

## Dependencies Required

Add to `pubspec.yaml` dev_dependencies:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  firebase_core_platform_interface: ^5.3.1
```

## Best Practices

1. **Always Reset Singleton**: Reset AnalyticsService before and after each test
2. **Stub All Used Methods**: Stub any Firebase method your code calls
3. **Verify Specific Parameters**: Don't just verify the method was called, verify with exact parameters
4. **Clean Up**: Always call `clearFirebaseMocks()` in `tearDownAll()`
5. **Use in Widget Tests**: This helper is primarily for widget tests where Firebase services are used

## Related Files
- `test/common/analytics_service_test.dart` - Unit tests for AnalyticsService
- `test/common/README_ANALYTICS_TEST.md` - Documentation for AnalyticsService tests
- `lib/common/analytics_service.dart` - AnalyticsService implementation

## Additional Resources
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Firebase Testing Guide](https://firebase.google.com/docs/flutter/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
