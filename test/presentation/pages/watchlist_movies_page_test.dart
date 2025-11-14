import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

class FakeWatchlistMoviesEvent extends Fake implements WatchlistMoviesEvent {}

class FakeWatchlistMoviesState extends Fake implements WatchlistMoviesState {}

void main() {
  late MockWatchlistMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistMoviesEvent());
    registerFallbackValue(FakeWatchlistMoviesState());
  });

  setUp(() {
    mockBloc = MockWatchlistMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesBloc>.value(
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

  group('WatchlistMoviesPage', () {
    testWidgets('should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(WatchlistMoviesLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(WatchlistMoviesHasData(tMovieList));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockBloc.state)
          .thenReturn(WatchlistMoviesError('Error message'));

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      expect(textFinder, findsOneWidget);
    });

    testWidgets('should display empty container when state is Empty',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(WatchlistMoviesEmpty());

      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });
  });
}
