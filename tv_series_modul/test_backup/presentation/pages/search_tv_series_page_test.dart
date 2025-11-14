import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series_modul/presentation/bloc/search_tv_series_bloc.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/search_tv_series_page.dart';
import 'package:tv_series_modul/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchTvSeriesBloc
    extends MockBloc<SearchTvSeriesEvent, SearchTvSeriesState>
    implements SearchTvSeriesBloc {}

class FakeSearchTvSeriesEvent extends Fake implements SearchTvSeriesEvent {}

class FakeSearchTvSeriesState extends Fake implements SearchTvSeriesState {}

void main() {
  late MockSearchTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchTvSeriesEvent());
    registerFallbackValue(FakeSearchTvSeriesState());
  });

  setUp(() {
    mockBloc = MockSearchTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('SearchTvSeriesPage', () {
    testWidgets('should display search field',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(SearchEmpty());

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search TV Series...'), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(SearchLoading());

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when error',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        const SearchError('Error message'),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('should display list of tv series when search has data',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        SearchHasData(testTvSeriesList),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TvSeriesCard), findsWidgets);
    });

    testWidgets('should display empty container when state is empty',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(SearchEmpty());

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should trigger search when text is entered',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(SearchEmpty());

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));
      await tester.enterText(find.byType(TextField), 'Breaking Bad');

      // assert
      verify(() => mockBloc.add(const OnQueryChanged('Breaking Bad'))).called(1);
    });

    testWidgets('should have correct app bar title',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(SearchEmpty());

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      expect(find.text('Search TV Series'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should have search result title',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(SearchEmpty());

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      expect(find.text('Search Result'), findsOneWidget);
    });

    testWidgets('should have search icon in text field',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(SearchEmpty());

      // act
      await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

      // assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.prefixIcon, isNotNull);
    });
  });
}
