import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series_modul/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:tv_series_modul/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class FakeWatchlistTvSeriesEvent extends Fake
    implements WatchlistTvSeriesEvent {}

class FakeWatchlistTvSeriesState extends Fake
    implements WatchlistTvSeriesState {}

void main() {
  late MockWatchlistTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvSeriesEvent());
    registerFallbackValue(FakeWatchlistTvSeriesState());
  });

  setUp(() {
    mockBloc = MockWatchlistTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('WatchlistTvSeriesPage', () {
    testWidgets('should display loading indicator when loading',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(WatchlistLoading());

      // act
      await tester
          .pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when error',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const WatchlistError('Error message'),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.text('Error message'), findsOneWidget);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });

    testWidgets('should display list of tv series when watchlist has data',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        WatchlistHasData(testTvSeriesList),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TvSeriesCard), findsWidgets);
    });

    testWidgets('should display no watchlist message when watchlist is empty',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(WatchlistEmpty());

      // act
      await tester
          .pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.text('No watchlist'), findsOneWidget);
    });

    testWidgets('should call FetchWatchlistTvSeries on init',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(WatchlistEmpty());

      // act
      await tester
          .pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));
      await tester.pump();

      // assert
      verify(() => mockBloc.add(FetchWatchlistTvSeries())).called(1);
    });

    testWidgets('should have correct app bar title',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(WatchlistEmpty());

      // act
      await tester
          .pumpWidget(makeTestableWidget(const WatchlistTvSeriesPage()));

      // assert
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
