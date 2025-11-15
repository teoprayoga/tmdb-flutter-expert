import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/firebase_mock_helper.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late MockFirebaseCrashlytics mockCrashlytics;

  setUpAll(() {
    // Setup Firebase mocks
    setupFirebaseMocks();
  });

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    mockCrashlytics = MockFirebaseCrashlytics();

    // Reset and configure AnalyticsService with mocks
    AnalyticsService.resetInstance();
    AnalyticsService(
      analytics: mockAnalytics,
      crashlytics: mockCrashlytics,
    );

    // Stub analytics methods
    when(() => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        )).thenAnswer((_) async => Future.value());

    when(() => mockCrashlytics.crash()).thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    AnalyticsService.resetInstance();
  });

  tearDownAll(() {
    clearFirebaseMocks();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display about content', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final textFinder = find.text(
        'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.');

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should have back button', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final backButtonFinder = find.byIcon(Icons.arrow_back);

    expect(backButtonFinder, findsOneWidget);
  });

  testWidgets('Page should display logo image', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final imageFinder = find.byType(Image);

    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Back button should be tappable', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final backButtonFinder = find.byIcon(Icons.arrow_back);
    expect(backButtonFinder, findsOneWidget);

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('Page should display Test Crashlytics button',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final crashlyticsButtonFinder = find.text('Test Crashlytics');

    expect(crashlyticsButtonFinder, findsOneWidget);
  });

  testWidgets(
      'Test Crashlytics button should call analytics and crashlytics when tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final crashlyticsButtonFinder = find.text('Test Crashlytics');
    expect(crashlyticsButtonFinder, findsOneWidget);

    await tester.tap(crashlyticsButtonFinder);
    await tester.pump();

    // Verify analytics event was logged
    verify(() => mockAnalytics.logEvent(
          name: 'button_click',
          parameters: {
            'button_name': 'test_crash',
            'screen_name': 'about_page',
          },
        )).called(1);

    // Verify crash was triggered
    verify(() => mockCrashlytics.crash()).called(1);
  });
}
