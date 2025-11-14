import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/search_movies_bloc.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchMoviesBloc
    extends MockBloc<SearchMoviesEvent, SearchMoviesState>
    implements SearchMoviesBloc {}

class FakeSearchMoviesEvent extends Fake implements SearchMoviesEvent {}

class FakeSearchMoviesState extends Fake implements SearchMoviesState {}

void main() {
  late MockSearchMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchMoviesEvent());
    registerFallbackValue(FakeSearchMoviesState());
  });

  setUp(() {
    mockBloc = MockSearchMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  group('SearchPage', () {
    testWidgets('should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(SearchMoviesLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      expect(centerFinder, findsAtLeastNWidgets(1));
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(SearchMoviesHasData(tMovieList));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(SearchMoviesError('Error message'));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('should display empty container when state is Empty',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(SearchMoviesEmpty());

      final containerFinder = find.byType(Container);

      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      expect(containerFinder, findsWidgets);
    });

    testWidgets('should have TextField for search input',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(SearchMoviesEmpty());

      final textFieldFinder = find.byType(TextField);

      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      expect(textFieldFinder, findsOneWidget);
    });
  });
}
