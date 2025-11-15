import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Analytics Events
  Future<void> logMovieView(int movieId, String movieTitle) async {
    await _analytics.logEvent(
      name: 'view_movie_detail',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
      },
    );
  }

  Future<void> logTvSeriesView(int tvSeriesId, String tvSeriesTitle) async {
    await _analytics.logEvent(
      name: 'view_tv_series_detail',
      parameters: {
        'tv_series_id': tvSeriesId,
        'tv_series_title': tvSeriesTitle,
      },
    );
  }

  Future<void> logSearch(String searchTerm, String searchType) async {
    await _analytics.logSearch(
      searchTerm: searchTerm,
      parameters: {
        'search_type': searchType,
      },
    );
  }

  Future<void> logAddToWatchlist(int itemId, String itemType, String itemTitle) async {
    await _analytics.logEvent(
      name: 'add_to_watchlist',
      parameters: {
        'item_id': itemId,
        'item_type': itemType,
        'item_title': itemTitle,
      },
    );
  }

  Future<void> logRemoveFromWatchlist(int itemId, String itemType, String itemTitle) async {
    await _analytics.logEvent(
      name: 'remove_from_watchlist',
      parameters: {
        'item_id': itemId,
        'item_type': itemType,
        'item_title': itemTitle,
      },
    );
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  Future<void> logButtonClick(String buttonName, String screenName) async {
    await _analytics.logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
        'screen_name': screenName,
      },
    );
  }

  // Crashlytics Methods
  void setUserIdentifier(String userId) {
    _crashlytics.setUserIdentifier(userId);
  }

  void setCustomKey(String key, dynamic value) {
    _crashlytics.setCustomKey(key, value);
  }

  Future<void> recordError(dynamic exception, StackTrace? stack, {String? reason, bool fatal = false}) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  // Test crash (only for testing purposes)
  Future<void> testCrash() async {
    _crashlytics.crash();
  }
}
