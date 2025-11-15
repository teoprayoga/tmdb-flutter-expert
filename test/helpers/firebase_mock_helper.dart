import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

/// Sets up Firebase mocks for testing.
/// This prevents "No Firebase App '[DEFAULT]' has been created" errors in tests.
void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

/// Sets up Firebase Core mocks
void setupFirebaseCoreMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_core'),
    (MethodCall methodCall) async {
      if (methodCall.method == 'Firebase#initializeCore') {
        return [
          {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': 'test-api-key',
              'appId': '1:123456789:android:abc123',
              'messagingSenderId': '123456789',
              'projectId': 'test-project',
            },
            'pluginConstants': {},
          }
        ];
      }
      if (methodCall.method == 'Firebase#initializeApp') {
        return {
          'name': methodCall.arguments['appName'],
          'options': methodCall.arguments['options'],
          'pluginConstants': {},
        };
      }
      return null;
    },
  );

  // Mock Firebase Analytics
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_analytics'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Analytics#logEvent':
        case 'Analytics#setUserId':
        case 'Analytics#setUserProperty':
        case 'Analytics#setCurrentScreen':
        case 'Analytics#setAnalyticsCollectionEnabled':
          return null;
        default:
          return null;
      }
    },
  );

  // Mock Firebase Crashlytics
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_crashlytics'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Crashlytics#checkForUnsentReports':
          return false;
        case 'Crashlytics#deleteUnsentReports':
        case 'Crashlytics#didCrashOnPreviousExecution':
        case 'Crashlytics#setCrashlyticsCollectionEnabled':
        case 'Crashlytics#sendUnsentReports':
        case 'Crashlytics#log':
        case 'Crashlytics#setCustomKey':
        case 'Crashlytics#setUserIdentifier':
        case 'Crashlytics#recordError':
        case 'Crashlytics#crash':
          return null;
        default:
          return null;
      }
    },
  );
}

/// Clears Firebase mocks after tests
void clearFirebaseMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_core'),
    null,
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_analytics'),
    null,
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_crashlytics'),
    null,
  );
}
