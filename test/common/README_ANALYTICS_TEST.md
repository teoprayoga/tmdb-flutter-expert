# AnalyticsService Test Documentation

## Overview
This document describes the comprehensive test suite for `AnalyticsService`, which handles Firebase Analytics and Crashlytics integration.

## Test File
- **Location**: `test/common/analytics_service_test.dart`
- **Framework**: Flutter Test with Mocktail for mocking
- **Coverage**: All public methods of AnalyticsService

## Running the Tests

### Run all tests
```bash
flutter test
```

### Run only analytics service tests
```bash
flutter test test/common/analytics_service_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### View coverage report
```bash
# Generate coverage
flutter test --coverage

# View in browser (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Structure

### 1. Mock Classes
```dart
class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}
class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}
```

These mocks allow us to test the AnalyticsService without actually calling Firebase services.

### 2. Test Groups

#### Group: AnalyticsService Singleton
Tests the singleton pattern implementation:
- ✅ Returns the same instance on multiple calls
- ✅ Creates new instance after reset

#### Group: Analytics Events
Tests all Firebase Analytics event logging methods:
- ✅ `logMovieView()` - Logs movie detail views
- ✅ `logTvSeriesView()` - Logs TV series detail views
- ✅ `logSearch()` - Logs search events
- ✅ `logAddToWatchlist()` - Logs watchlist additions
- ✅ `logRemoveFromWatchlist()` - Logs watchlist removals
- ✅ `logScreenView()` - Logs screen navigation
- ✅ `logButtonClick()` - Logs button interactions

#### Group: Crashlytics Methods
Tests all Firebase Crashlytics methods:
- ✅ `setUserIdentifier()` - Sets user ID for crash reports
- ✅ `setCustomKey()` - Sets custom metadata (String, Int, Bool)
- ✅ `recordError()` - Records errors with/without optional parameters
- ✅ `log()` - Logs custom messages
- ✅ `testCrash()` - Triggers test crash

#### Group: Error Handling
Tests error scenarios:
- ✅ Analytics errors are properly propagated
- ✅ Crashlytics errors are properly propagated

#### Group: Integration Scenarios
Tests real-world usage patterns:
- ✅ Multiple sequential analytics calls
- ✅ Combined analytics and crashlytics calls

## Test Coverage

### Methods Tested: 12/12 (100%)

**Analytics Methods (7):**
1. ✅ logMovieView
2. ✅ logTvSeriesView
3. ✅ logSearch
4. ✅ logAddToWatchlist
5. ✅ logRemoveFromWatchlist
6. ✅ logScreenView
7. ✅ logButtonClick

**Crashlytics Methods (5):**
1. ✅ setUserIdentifier
2. ✅ setCustomKey
3. ✅ recordError
4. ✅ log
5. ✅ testCrash

### Test Cases: 19 Total

| Category | Test Cases |
|----------|-----------|
| Singleton Pattern | 2 |
| Analytics Events | 7 |
| Crashlytics Methods | 6 |
| Error Handling | 2 |
| Integration | 2 |

## Key Testing Patterns

### 1. Arrange-Act-Assert (AAA)
All tests follow the AAA pattern:
```dart
test('description', () async {
  // Arrange - Set up test data and mocks
  const movieId = 123;
  when(() => mockAnalytics.logEvent(...)).thenAnswer((_) async => Future.value());

  // Act - Call the method being tested
  await analyticsService.logMovieView(movieId, 'Test Movie');

  // Assert - Verify the expected behavior
  verify(() => mockAnalytics.logEvent(...)).called(1);
});
```

### 2. Mock Verification
Tests verify that the correct Firebase methods are called with the correct parameters:
```dart
verify(() => mockAnalytics.logEvent(
  name: 'view_movie_detail',
  parameters: {
    'movie_id': movieId,
    'movie_title': movieTitle,
  },
)).called(1);
```

### 3. Singleton Reset
Each test resets the singleton to ensure test isolation:
```dart
setUp(() {
  AnalyticsService.resetInstance();
  analyticsService = AnalyticsService(
    analytics: mockAnalytics,
    crashlytics: mockCrashlytics,
  );
});
```

## Example Test Output

```
✓ AnalyticsService Singleton should return the same instance when called multiple times
✓ AnalyticsService Singleton should create new instance after reset
✓ Analytics Events logMovieView should call analytics.logEvent with correct parameters
✓ Analytics Events logTvSeriesView should call analytics.logEvent with correct parameters
✓ Analytics Events logSearch should call analytics.logSearch with correct parameters
✓ Analytics Events logAddToWatchlist should call analytics.logEvent with correct parameters
✓ Analytics Events logRemoveFromWatchlist should call analytics.logEvent with correct parameters
✓ Analytics Events logScreenView should call analytics.logScreenView with correct parameters
✓ Analytics Events logButtonClick should call analytics.logEvent with correct parameters
✓ Crashlytics Methods setUserIdentifier should call crashlytics.setUserIdentifier
✓ Crashlytics Methods setCustomKey should call crashlytics.setCustomKey with correct parameters
✓ Crashlytics Methods setCustomKey should handle different value types
✓ Crashlytics Methods recordError should call crashlytics.recordError with correct parameters
✓ Crashlytics Methods recordError should work without optional parameters
✓ Crashlytics Methods log should call crashlytics.log with correct message
✓ Crashlytics Methods testCrash should call crashlytics.crash
✓ Error Handling logMovieView should handle analytics errors gracefully
✓ Error Handling recordError should handle crashlytics errors gracefully
✓ Integration Scenarios should handle multiple analytics calls in sequence
✓ Integration Scenarios should handle analytics and crashlytics calls together

All tests passed!
```

## Continuous Integration

These tests can be integrated into CI/CD pipelines:

### GitHub Actions Example
```yaml
name: Flutter Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test test/common/analytics_service_test.dart
```

## Refactoring for Testability

The `AnalyticsService` was refactored to support dependency injection:

**Before (Not Testable):**
```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();
}
```

**After (Testable):**
```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

  factory AnalyticsService({
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
  }) {
    _instance ??= AnalyticsService._internal(
      analytics: analytics ?? FirebaseAnalytics.instance,
      crashlytics: crashlytics ?? FirebaseCrashlytics.instance,
    );
    return _instance!;
  }

  static void resetInstance() {
    _instance = null;
  }
}
```

This allows:
1. Injecting mock instances during tests
2. Using real Firebase instances in production
3. Resetting the singleton between tests
4. Maintaining the singleton pattern for production use

## Best Practices Demonstrated

1. ✅ **Comprehensive Coverage**: All public methods tested
2. ✅ **Mock Usage**: Firebase services are mocked to avoid actual API calls
3. ✅ **Test Isolation**: Each test is independent via setUp/tearDown
4. ✅ **Clear Naming**: Test names describe the expected behavior
5. ✅ **AAA Pattern**: Arrange-Act-Assert structure in all tests
6. ✅ **Parameter Verification**: All parameters are verified, not just method calls
7. ✅ **Edge Cases**: Optional parameters and error scenarios tested
8. ✅ **Integration Tests**: Real-world usage patterns validated

## Troubleshooting

### Tests fail with "MissingStubError"
Make sure all Firebase method calls are stubbed:
```dart
when(() => mockAnalytics.logEvent(
  name: any(named: 'name'),
  parameters: any(named: 'parameters'),
)).thenAnswer((_) async => Future.value());
```

### Singleton issues between tests
Ensure `resetInstance()` is called in `setUp()` and `tearDown()`:
```dart
setUp(() {
  AnalyticsService.resetInstance();
});

tearDown(() {
  AnalyticsService.resetInstance();
});
```

### Import errors
Ensure mocktail is added to `pubspec.yaml`:
```yaml
dev_dependencies:
  mocktail: ^1.0.4
```

## Future Improvements

Potential enhancements for the test suite:
1. Add widget tests for pages using AnalyticsService
2. Add integration tests with actual Firebase Test Lab
3. Add performance tests for high-frequency event logging
4. Add tests for analytics data validation
5. Add tests for offline scenarios

## Related Documentation
- [FIREBASE_INTEGRATION.md](../../FIREBASE_INTEGRATION.md) - Firebase setup guide
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
