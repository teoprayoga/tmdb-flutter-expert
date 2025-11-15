import 'package:ditonton/common/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late MockFirebaseCrashlytics mockCrashlytics;
  late AnalyticsService analyticsService;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    mockCrashlytics = MockFirebaseCrashlytics();

    // Reset singleton before each test
    AnalyticsService.resetInstance();

    // Create instance with mocks
    analyticsService = AnalyticsService(
      analytics: mockAnalytics,
      crashlytics: mockCrashlytics,
    );
  });

  tearDown(() {
    // Reset singleton after each test
    AnalyticsService.resetInstance();
  });

  group('AnalyticsService Singleton', () {
    test('should return the same instance when called multiple times', () {
      // Reset and create first instance
      AnalyticsService.resetInstance();
      final instance1 = AnalyticsService(
        analytics: mockAnalytics,
        crashlytics: mockCrashlytics,
      );

      // Second call should return the same instance
      final instance2 = AnalyticsService();

      expect(instance1, equals(instance2));
    });

    test('should create new instance after reset', () {
      // Create first instance
      final instance1 = analyticsService;

      // Reset and create new instance
      AnalyticsService.resetInstance();
      final instance2 = AnalyticsService(
        analytics: mockAnalytics,
        crashlytics: mockCrashlytics,
      );

      expect(instance1, isNot(equals(instance2)));
    });
  });

  group('Analytics Events', () {
    test('logMovieView should call analytics.logEvent with correct parameters',
        () async {
      // Arrange
      const movieId = 123;
      const movieTitle = 'Test Movie';
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logMovieView(movieId, movieTitle);

      // Assert
      verify(() => mockAnalytics.logEvent(
            name: 'view_movie_detail',
            parameters: {
              'movie_id': movieId,
              'movie_title': movieTitle,
            },
          )).called(1);
    });

    test('logTvSeriesView should call analytics.logEvent with correct parameters',
        () async {
      // Arrange
      const tvSeriesId = 456;
      const tvSeriesTitle = 'Test TV Series';
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logTvSeriesView(tvSeriesId, tvSeriesTitle);

      // Assert
      verify(() => mockAnalytics.logEvent(
            name: 'view_tv_series_detail',
            parameters: {
              'tv_series_id': tvSeriesId,
              'tv_series_title': tvSeriesTitle,
            },
          )).called(1);
    });

    test('logSearch should call analytics.logSearch with correct parameters',
        () async {
      // Arrange
      const searchTerm = 'action movies';
      const searchType = 'movie';
      when(() => mockAnalytics.logSearch(
            searchTerm: any(named: 'searchTerm'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logSearch(searchTerm, searchType);

      // Assert
      verify(() => mockAnalytics.logSearch(
            searchTerm: searchTerm,
            parameters: {
              'search_type': searchType,
            },
          )).called(1);
    });

    test(
        'logAddToWatchlist should call analytics.logEvent with correct parameters',
        () async {
      // Arrange
      const itemId = 789;
      const itemType = 'movie';
      const itemTitle = 'Test Movie';
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logAddToWatchlist(itemId, itemType, itemTitle);

      // Assert
      verify(() => mockAnalytics.logEvent(
            name: 'add_to_watchlist',
            parameters: {
              'item_id': itemId,
              'item_type': itemType,
              'item_title': itemTitle,
            },
          )).called(1);
    });

    test(
        'logRemoveFromWatchlist should call analytics.logEvent with correct parameters',
        () async {
      // Arrange
      const itemId = 789;
      const itemType = 'movie';
      const itemTitle = 'Test Movie';
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logRemoveFromWatchlist(
          itemId, itemType, itemTitle);

      // Assert
      verify(() => mockAnalytics.logEvent(
            name: 'remove_from_watchlist',
            parameters: {
              'item_id': itemId,
              'item_type': itemType,
              'item_title': itemTitle,
            },
          )).called(1);
    });

    test(
        'logScreenView should call analytics.logScreenView with correct parameters',
        () async {
      // Arrange
      const screenName = 'movie_detail_screen';
      when(() => mockAnalytics.logScreenView(
            screenName: any(named: 'screenName'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logScreenView(screenName);

      // Assert
      verify(() => mockAnalytics.logScreenView(
            screenName: screenName,
          )).called(1);
    });

    test(
        'logButtonClick should call analytics.logEvent with correct parameters',
        () async {
      // Arrange
      const buttonName = 'add_to_watchlist_button';
      const screenName = 'movie_detail_screen';
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logButtonClick(buttonName, screenName);

      // Assert
      verify(() => mockAnalytics.logEvent(
            name: 'button_click',
            parameters: {
              'button_name': buttonName,
              'screen_name': screenName,
            },
          )).called(1);
    });
  });

  group('Crashlytics Methods', () {
    test('setUserIdentifier should call crashlytics.setUserIdentifier', () {
      // Arrange
      const userId = 'user123';
      when(() => mockCrashlytics.setUserIdentifier(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      analyticsService.setUserIdentifier(userId);

      // Assert
      verify(() => mockCrashlytics.setUserIdentifier(userId)).called(1);
    });

    test('setCustomKey should call crashlytics.setCustomKey with correct parameters',
        () {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';
      when(() => mockCrashlytics.setCustomKey(any(), any()))
          .thenAnswer((_) {});

      // Act
      analyticsService.setCustomKey(key, value);

      // Assert
      verify(() => mockCrashlytics.setCustomKey(key, value)).called(1);
    });

    test('setCustomKey should handle different value types', () {
      // Arrange
      const key = 'test_key';
      when(() => mockCrashlytics.setCustomKey(any(), any()))
          .thenAnswer((_) {});

      // Act & Assert - String
      analyticsService.setCustomKey(key, 'string_value');
      verify(() => mockCrashlytics.setCustomKey(key, 'string_value')).called(1);

      // Act & Assert - Int
      analyticsService.setCustomKey(key, 42);
      verify(() => mockCrashlytics.setCustomKey(key, 42)).called(1);

      // Act & Assert - Bool
      analyticsService.setCustomKey(key, true);
      verify(() => mockCrashlytics.setCustomKey(key, true)).called(1);
    });

    test('recordError should call crashlytics.recordError with correct parameters',
        () async {
      // Arrange
      final exception = Exception('Test exception');
      final stack = StackTrace.current;
      const reason = 'Test reason';
      const fatal = true;
      when(() => mockCrashlytics.recordError(
            any(),
            any(),
            reason: any(named: 'reason'),
            fatal: any(named: 'fatal'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.recordError(
        exception,
        stack,
        reason: reason,
        fatal: fatal,
      );

      // Assert
      verify(() => mockCrashlytics.recordError(
            exception,
            stack,
            reason: reason,
            fatal: fatal,
          )).called(1);
    });

    test('recordError should work without optional parameters', () async {
      // Arrange
      final exception = Exception('Test exception');
      final stack = StackTrace.current;
      when(() => mockCrashlytics.recordError(
            any(),
            any(),
            reason: any(named: 'reason'),
            fatal: any(named: 'fatal'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.recordError(exception, stack);

      // Assert
      verify(() => mockCrashlytics.recordError(
            exception,
            stack,
            reason: null,
            fatal: false,
          )).called(1);
    });

    test('log should call crashlytics.log with correct message', () async {
      // Arrange
      const message = 'Test log message';
      when(() => mockCrashlytics.log(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.log(message);

      // Assert
      verify(() => mockCrashlytics.log(message)).called(1);
    });

    test('testCrash should call crashlytics.crash', () async {
      // Arrange
      when(() => mockCrashlytics.crash())
          .thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.testCrash();

      // Assert
      verify(() => mockCrashlytics.crash()).called(1);
    });
  });

  group('Error Handling', () {
    test('logMovieView should handle analytics errors gracefully', () async {
      // Arrange
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenThrow(Exception('Analytics error'));

      // Act & Assert
      expect(
        () => analyticsService.logMovieView(1, 'Test'),
        throwsA(isA<Exception>()),
      );
    });

    test('recordError should handle crashlytics errors gracefully', () async {
      // Arrange
      final exception = Exception('Test exception');
      final stack = StackTrace.current;
      when(() => mockCrashlytics.recordError(
            any(),
            any(),
            reason: any(named: 'reason'),
            fatal: any(named: 'fatal'),
          )).thenThrow(Exception('Crashlytics error'));

      // Act & Assert
      expect(
        () => analyticsService.recordError(exception, stack),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Integration Scenarios', () {
    test('should handle multiple analytics calls in sequence', () async {
      // Arrange
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());
      when(() => mockAnalytics.logScreenView(
            screenName: any(named: 'screenName'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await analyticsService.logScreenView('home');
      await analyticsService.logMovieView(1, 'Movie 1');
      await analyticsService.logAddToWatchlist(1, 'movie', 'Movie 1');

      // Assert
      verify(() => mockAnalytics.logScreenView(screenName: 'home')).called(1);
      verify(() => mockAnalytics.logEvent(
            name: 'view_movie_detail',
            parameters: any(named: 'parameters'),
          )).called(1);
      verify(() => mockAnalytics.logEvent(
            name: 'add_to_watchlist',
            parameters: any(named: 'parameters'),
          )).called(1);
    });

    test('should handle analytics and crashlytics calls together', () async {
      // Arrange
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => Future.value());
      when(() => mockCrashlytics.log(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockCrashlytics.setCustomKey(any(), any()))
          .thenAnswer((_) {});

      // Act
      await analyticsService.logMovieView(1, 'Movie 1');
      analyticsService.setCustomKey('last_movie_viewed', 1);
      await analyticsService.log('User viewed movie 1');

      // Assert
      verify(() => mockAnalytics.logEvent(
            name: 'view_movie_detail',
            parameters: any(named: 'parameters'),
          )).called(1);
      verify(() => mockCrashlytics.setCustomKey('last_movie_viewed', 1))
          .called(1);
      verify(() => mockCrashlytics.log('User viewed movie 1')).called(1);
    });
  });
}
