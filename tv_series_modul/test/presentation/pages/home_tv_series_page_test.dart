import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series_modul/presentation/bloc/tv_series_list_bloc.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/home_tv_series_page.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/on_the_air_tv_series_page.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/search_tv_series_page.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:tv_series_modul/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesListBloc
    extends MockBloc<TvSeriesListEvent, TvSeriesListState>
    implements TvSeriesListBloc {}

class FakeTvSeriesListEvent extends Fake implements TvSeriesListEvent {}

class FakeTvSeriesListState extends Fake implements TvSeriesListState {}

void main() {
  late MockTvSeriesListBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvSeriesListEvent());
    registerFallbackValue(FakeTvSeriesListState());
  });

  setUp(() {
    mockBloc = MockTvSeriesListBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesListBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
        routes: {
          SearchTvSeriesPage.routeName: (context) =>
              const SearchTvSeriesPage(),
          WatchlistTvSeriesPage.routeName: (context) =>
              const WatchlistTvSeriesPage(),
          PopularTvSeriesPage.routeName: (context) =>
              const PopularTvSeriesPage(),
          TopRatedTvSeriesPage.routeName: (context) =>
              const TopRatedTvSeriesPage(),
          OnTheAirTvSeriesPage.routeName: (context) =>
              const OnTheAirTvSeriesPage(),
        },
      ),
    );
  }

  group('HomeTvSeriesPage', () {
    testWidgets('should have correct app bar title and actions',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.text('TV Series'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('should call fetch events on init',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));
      await tester.pump();

      // assert
      verify(() => mockBloc.add(FetchPopularTvSeries())).called(1);
      verify(() => mockBloc.add(FetchTopRatedTvSeries())).called(1);
      verify(() => mockBloc.add(FetchOnTheAirTvSeries())).called(1);
    });

    testWidgets('should display three sections',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.text('On The Air'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('should have See More buttons for each section',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.text('See More'), findsNWidgets(3));
    });

    testWidgets('should display loading for on the air section when loading',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(isOnTheAirLoading: true),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('should display on the air tv series when data is loaded',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesListState(onTheAirTvSeries: testTvSeriesList),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.byType(TvSeriesCard), findsWidgets);
    });

    testWidgets('should display popular tv series when data is loaded',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesListState(popularTvSeries: testTvSeriesList),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.byType(TvSeriesCard), findsWidgets);
    });

    testWidgets('should display top rated tv series when data is loaded',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesListState(topRatedTvSeries: testTvSeriesList),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.byType(TvSeriesCard), findsWidgets);
    });

    testWidgets('should display error message for on the air when error',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(onTheAirMessage: 'Error message'),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('should navigate to search page when search icon is tapped',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(SearchTvSeriesPage), findsOneWidget);
    });

    testWidgets('should navigate to watchlist page when bookmark icon is tapped',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(WatchlistTvSeriesPage), findsOneWidget);
    });

    testWidgets('should navigate to on the air page when see more is tapped',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));
      final seeMoreButtons = find.text('See More');
      await tester.tap(seeMoreButtons.first);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(OnTheAirTvSeriesPage), findsOneWidget);
    });

    testWidgets('should display no data message when list is empty',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(
          onTheAirTvSeries: [],
          popularTvSeries: [],
          topRatedTvSeries: [],
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

      // assert
      expect(find.text('No data'), findsNWidgets(3));
    });
  });
}
