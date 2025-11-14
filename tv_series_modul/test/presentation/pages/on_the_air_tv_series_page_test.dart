import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series_modul/presentation/bloc/tv_series_list_bloc.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/on_the_air_tv_series_page.dart';
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
      ),
    );
  }

  group('OnTheAirTvSeriesPage', () {
    testWidgets('should display loading indicator when loading',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(isOnTheAirLoading: true),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when error',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(onTheAirMessage: 'Error message'),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

      // assert
      expect(find.text('Error message'), findsOneWidget);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });

    testWidgets('should display list of tv series when data is loaded',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesListState(onTheAirTvSeries: testTvSeriesList),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TvSeriesCard), findsWidgets);
    });

    testWidgets('should display no data message when list is empty',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(onTheAirTvSeries: []),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

      // assert
      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('should call FetchOnTheAirTvSeries on init',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));
      await tester.pump();

      // assert
      verify(() => mockBloc.add(FetchOnTheAirTvSeries())).called(1);
    });

    testWidgets('should have correct app bar title',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const TvSeriesListState(),
      );

      // act
      await tester
          .pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

      // assert
      expect(find.text('On The Air TV Series'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
