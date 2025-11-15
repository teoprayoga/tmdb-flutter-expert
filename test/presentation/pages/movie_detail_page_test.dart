import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/firebase_mock_helper.dart';

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  late MockMovieDetailBloc mockBloc;
  late MockFirebaseAnalytics mockAnalytics;
  late MockFirebaseCrashlytics mockCrashlytics;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());

    // Setup Firebase mocks
    setupFirebaseMocks();
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
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

    when(() => mockAnalytics.logScreenView(
          screenName: any(named: 'screenName'),
        )).thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    AnalyticsService.resetInstance();
  });

  tearDownAll(() {
    clearFirebaseMocks();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(MovieDetailState(
      movieDetail: testMovieDetail,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(MovieDetailState(
      movieDetail: testMovieDetail,
      recommendations: <Movie>[],
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        MovieDetailState(
          movieDetail: testMovieDetail,
          recommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
        MovieDetailState(
          movieDetail: testMovieDetail,
          recommendations: <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: MovieDetailState(
        movieDetail: testMovieDetail,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('should display loading indicator when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const MovieDetailState(
      isLoading: true,
    ));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display movie detail when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(MovieDetailState(
      movieDetail: testMovieDetail,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text(testMovieDetail.title), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
  });
}
