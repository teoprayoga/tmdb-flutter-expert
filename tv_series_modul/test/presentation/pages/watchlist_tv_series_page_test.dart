import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series_modul/domain/entities/tv_series.dart';
import 'package:tv_series_modul/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tv_series_modul/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:tv_series_modul/presentation/widgets/tv_series_card.dart';

// Mock classes for WatchlistTvSeriesBloc
class MockWatchlistTvSeriesBloc extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class FakeWatchlistTvSeriesEvent extends Fake implements WatchlistTvSeriesEvent {}

class FakeWatchlistTvSeriesState extends Fake implements WatchlistTvSeriesState {}

// Mock classes for TvSeriesDetailBloc
class MockTvSeriesDetailBloc extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState> implements TvSeriesDetailBloc {}

class FakeTvSeriesDetailEvent extends Fake implements TvSeriesDetailEvent {}

class FakeTvSeriesDetailState extends Fake implements TvSeriesDetailState {}

void main() {
  late MockWatchlistTvSeriesBloc mockWatchlistBloc;
  late MockTvSeriesDetailBloc mockDetailBloc;

  // Test data
  final testTvSeries = TvSeries(
    // adult: false,
    backdropPath: '/path.jpg',
    genreIds: const [1, 2],
    id: 1,
    originCountry: const ['US'],
    // originalLanguage: 'en',
    // originalName: 'Test TV Series',
    overview: 'Test overview',
    // popularity: 100.0,
    posterPath: '/poster.jpg',
    firstAirDate: '2020-01-01',
    name: 'Test TV Series',
    voteAverage: 8.0,
    voteCount: 1000,
  );

  final testTvSeriesList = [testTvSeries];

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvSeriesEvent());
    registerFallbackValue(FakeWatchlistTvSeriesState());
    registerFallbackValue(FakeTvSeriesDetailEvent());
    registerFallbackValue(FakeTvSeriesDetailState());
  });

  setUp(() {
    mockWatchlistBloc = MockWatchlistTvSeriesBloc();
    mockDetailBloc = MockTvSeriesDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistTvSeriesBloc>.value(
          value: mockWatchlistBloc,
        ),
        BlocProvider<TvSeriesDetailBloc>.value(
          value: mockDetailBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('WatchlistTvSeriesPage', () {
    testWidgets('should have correct route name', (WidgetTester tester) async {
      expect(WatchlistTvSeriesPage.routeName, '/watchlist-tv-series');
    });

    testWidgets('should display loading indicator when loading', (WidgetTester tester) async {
      // arrange
      when(() => mockWatchlistBloc.state).thenReturn(WatchlistLoading());
      when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

      // act
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    // testWidgets('should display error message when error', (WidgetTester tester) async {
    //   // arrange
    //   when(() => mockWatchlistBloc.state).thenReturn(
    //     const WatchlistError('Failed to fetch watchlist'),
    //   );
    //   when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());
    //
    //   // act
    //   await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
    //
    //   // assert
    //   expect(find.text('Failed to fetch watchlist'), findsOneWidget);
    //   expect(find.byKey(const Key('error_message')), findsOneWidget);
    //   expect(find.byType(Center), findsNWidgets(2)); // One for error, one parent
    // });

    testWidgets('should display list of tv series when watchlist has data', (WidgetTester tester) async {
      // arrange
      when(() => mockWatchlistBloc.state).thenReturn(
        WatchlistHasData(testTvSeriesList),
      );
      when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

      // act
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TvSeriesCard), findsNWidgets(testTvSeriesList.length));
    });

    testWidgets('should display no watchlist message when watchlist is empty', (WidgetTester tester) async {
      // arrange
      when(() => mockWatchlistBloc.state).thenReturn(WatchlistEmpty());
      when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

      // act
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.text('No watchlist'), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should display empty list when watchlist has empty data', (WidgetTester tester) async {
      // arrange
      when(() => mockWatchlistBloc.state).thenReturn(
        const WatchlistHasData([]),
      );
      when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

      // act
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TvSeriesCard), findsNothing);
    });

    testWidgets('should call FetchWatchlistTvSeries on init', (WidgetTester tester) async {
      // arrange
      when(() => mockWatchlistBloc.state).thenReturn(WatchlistEmpty());
      when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

      // act
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
      await tester.pump();

      // assert
      verify(() => mockWatchlistBloc.add(FetchWatchlistTvSeries())).called(1);
    });

    testWidgets('should have correct app bar title', (WidgetTester tester) async {
      // arrange
      when(() => mockWatchlistBloc.state).thenReturn(WatchlistEmpty());
      when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

      // act
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should have correct padding', (WidgetTester tester) async {
      // arrange
      when(() => mockWatchlistBloc.state).thenReturn(WatchlistEmpty());
      when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

      // act
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(padding.padding, const EdgeInsets.all(8.0));
    });

    group('TvSeriesDetailBloc listener', () {
      testWidgets('should fetch watchlist when watchlist message is not empty', (WidgetTester tester) async {
        // arrange
        when(() => mockWatchlistBloc.state).thenReturn(WatchlistEmpty());
        whenListen(
          mockDetailBloc,
          Stream.fromIterable([
            const TvSeriesDetailState(),
            const TvSeriesDetailState(watchlistMessage: 'Added to Watchlist'),
          ]),
          initialState: const TvSeriesDetailState(),
        );

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
        await tester.pump();

        // assert
        // Should be called twice: once on init, once from listener
        verify(() => mockWatchlistBloc.add(FetchWatchlistTvSeries())).called(2);
      });

      testWidgets('should not fetch watchlist when watchlist message is empty', (WidgetTester tester) async {
        // arrange
        when(() => mockWatchlistBloc.state).thenReturn(WatchlistEmpty());
        whenListen(
          mockDetailBloc,
          Stream.fromIterable([
            const TvSeriesDetailState(),
            const TvSeriesDetailState(watchlistMessage: ''),
          ]),
          initialState: const TvSeriesDetailState(),
        );

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
        await tester.pump();

        // assert
        // Should only be called once on init
        verify(() => mockWatchlistBloc.add(FetchWatchlistTvSeries())).called(1);
      });

      testWidgets('should react to multiple watchlist messages', (WidgetTester tester) async {
        // arrange
        when(() => mockWatchlistBloc.state).thenReturn(WatchlistEmpty());
        whenListen(
          mockDetailBloc,
          Stream.fromIterable([
            const TvSeriesDetailState(),
            const TvSeriesDetailState(watchlistMessage: 'Added to Watchlist'),
            const TvSeriesDetailState(watchlistMessage: ''),
            const TvSeriesDetailState(watchlistMessage: 'Removed from Watchlist'),
          ]),
          initialState: const TvSeriesDetailState(),
        );

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
        await tester.pump();

        // assert
        // Should be called: 1x on init + 2x from non-empty messages
        verify(() => mockWatchlistBloc.add(FetchWatchlistTvSeries())).called(3);
      });
    });

    group('ListView builder', () {
      testWidgets('should render correct number of items', (WidgetTester tester) async {
        // arrange
        final multipleItems = [
          testTvSeries,
          TvSeries(
            // adult: false,
            backdropPath: '/path2.jpg',
            genreIds: const [3, 4],
            id: 2,
            originCountry: const ['UK'],
            // originalLanguage: 'en',
            // originalName: 'Test TV Series 2',
            overview: 'Test overview 2',
            // popularity: 90.0,
            posterPath: '/poster2.jpg',
            firstAirDate: '2021-01-01',
            name: 'Test TV Series 2',
            voteAverage: 7.5,
            voteCount: 800,
          ),
        ];

        when(() => mockWatchlistBloc.state).thenReturn(
          WatchlistHasData(multipleItems),
        );
        when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

        // assert
        expect(find.byType(TvSeriesCard), findsNWidgets(2));
        final listViewFinder = find.byType(ListView);
        final listView = tester.widget<ListView>(listViewFinder);
        expect(listView.semanticChildCount, 2);
      });

      testWidgets('should pass correct tv series to TvSeriesCard', (WidgetTester tester) async {
        // arrange
        when(() => mockWatchlistBloc.state).thenReturn(
          WatchlistHasData(testTvSeriesList),
        );
        when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

        // assert
        final tvSeriesCard = tester.widget<TvSeriesCard>(find.byType(TvSeriesCard));
        expect(tvSeriesCard.tvSeries, testTvSeries);
      });
    });

    // group('State transitions', () {
    //   testWidgets('should handle state transition from loading to data', (WidgetTester tester) async {
    //     // arrange
    //     final stateController = StreamController<WatchlistTvSeriesState>();
    //     whenListen(
    //       mockWatchlistBloc,
    //       stateController.stream,
    //       initialState: WatchlistLoading(),
    //     );
    //     when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());
    //
    //     // act
    //     await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
    //
    //     // assert initial loading state
    //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
    //
    //     // emit new state
    //     stateController.add(WatchlistHasData(testTvSeriesList));
    //     await tester.pump();
    //
    //     // assert data state
    //     expect(find.byType(CircularProgressIndicator), findsNothing);
    //     expect(find.byType(ListView), findsOneWidget);
    //     expect(find.byType(TvSeriesCard), findsOneWidget);
    //
    //     await stateController.close();
    //   });
    //
    //   testWidgets('should handle state transition from error to data', (WidgetTester tester) async {
    //     // arrange
    //     final stateController = StreamController<WatchlistTvSeriesState>();
    //     whenListen(
    //       mockWatchlistBloc,
    //       stateController.stream,
    //       initialState: const WatchlistError('Network Error'),
    //     );
    //     when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());
    //
    //     // act
    //     await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
    //
    //     // assert initial error state
    //     expect(find.text('Network Error'), findsOneWidget);
    //
    //     // emit new state
    //     stateController.add(WatchlistHasData(testTvSeriesList));
    //     await tester.pump();
    //
    //     // assert data state
    //     expect(find.text('Network Error'), findsNothing);
    //     expect(find.byType(ListView), findsOneWidget);
    //
    //     await stateController.close();
    //   });
    // });

    group('Widget key tests', () {
      testWidgets('should verify widget exists with key', (WidgetTester tester) async {
        // arrange
        when(() => mockWatchlistBloc.state).thenReturn(
          const WatchlistError('Test Error'),
        );
        when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

        // assert
        expect(find.byKey(const Key('error_message')), findsOneWidget);
        final errorWidget = tester.widget<Center>(find.byKey(const Key('error_message')));
        expect(errorWidget.child, isA<Text>());
      });
    });

    group('Edge cases', () {
      testWidgets('should handle very long error messages', (WidgetTester tester) async {
        // arrange
        const longErrorMessage = 'This is a very long error message that '
            'might wrap to multiple lines on smaller screens. '
            'It should still be displayed correctly without overflow.';

        when(() => mockWatchlistBloc.state).thenReturn(
          const WatchlistError(longErrorMessage),
        );
        when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

        // assert
        expect(find.text(longErrorMessage), findsOneWidget);
        expect(tester.takeException(), isNull); // No overflow errors
      });

      testWidgets('should handle rapid state changes', (WidgetTester tester) async {
        // arrange
        final stateController = StreamController<WatchlistTvSeriesState>();
        whenListen(
          mockWatchlistBloc,
          stateController.stream,
          initialState: WatchlistLoading(),
        );
        when(() => mockDetailBloc.state).thenReturn(const TvSeriesDetailState());

        // act
        await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

        // rapid state changes
        stateController.add(const WatchlistError('Error'));
        stateController.add(WatchlistLoading());
        stateController.add(WatchlistHasData(testTvSeriesList));
        await tester.pump();

        // assert final state
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(TvSeriesCard), findsOneWidget);

        await stateController.close();
      });
    });
  });

  group('Integration tests', () {
    testWidgets('complete user flow: loading -> data -> updated from detail bloc', (WidgetTester tester) async {
      // arrange
      final watchlistStateController = StreamController<WatchlistTvSeriesState>();
      final detailStateController = StreamController<TvSeriesDetailState>();

      whenListen(
        mockWatchlistBloc,
        watchlistStateController.stream,
        initialState: WatchlistLoading(),
      );

      whenListen(
        mockDetailBloc,
        detailStateController.stream,
        initialState: const TvSeriesDetailState(),
      );

      // act & assert
      await tester.pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // Initial loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => mockWatchlistBloc.add(FetchWatchlistTvSeries())).called(1);

      // Data loaded
      watchlistStateController.add(WatchlistHasData(testTvSeriesList));
      await tester.pump();
      expect(find.byType(ListView), findsOneWidget);

      // Detail bloc triggers update
      detailStateController.add(const TvSeriesDetailState(watchlistMessage: 'Item removed'));
      await tester.pump();
      verify(() => mockWatchlistBloc.add(FetchWatchlistTvSeries())).called(1);

      // Clean up
      await watchlistStateController.close();
      await detailStateController.close();
    });
  });
}
