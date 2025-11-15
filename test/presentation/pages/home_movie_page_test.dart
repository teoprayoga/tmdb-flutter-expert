import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class FakeMovieListEvent extends Fake implements MovieListEvent {}

class FakeMovieListState extends Fake implements MovieListState {}

void main() {
  late MockMovieListBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieListEvent());
    registerFallbackValue(FakeMovieListState());
  });

  setUp(() {
    mockBloc = MockMovieListBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieListBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when now playing is loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState(
      isNowPlayingLoading: true,
      isPopularLoading: true,
      isTopRatedLoading: true,
    ));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(progressBarFinder, findsWidgets);
  });

  // testWidgets('Page should display MovieList when data is loaded', (WidgetTester tester) async {
  //   when(() => mockBloc.state).thenReturn(const MovieListState(
  //     nowPlayingMovies: <Movie>[],
  //     popularMovies: <Movie>[],
  //     topRatedMovies: <Movie>[],
  //   ));
  //
  //   final movieListFinder = find.byType(MovieList);
  //
  //   await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));
  //
  //   expect(movieListFinder, findsNWidgets(3));
  // });

  testWidgets('Page should display text Failed when error occurs', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState(
      nowPlayingMessage: 'Failed',
      popularMessage: 'Failed',
      topRatedMessage: 'Failed',
    ));

    final textFinder = find.text('Failed');

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(textFinder, findsNWidgets(3));
  });

  // testWidgets('Page should have drawer with menu items', (WidgetTester tester) async {
  //   when(() => mockBloc.state).thenReturn(const MovieListState(
  //     nowPlayingMovies: <Movie>[],
  //     popularMovies: <Movie>[],
  //     topRatedMovies: <Movie>[],
  //   ));
  //
  //   await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));
  //
  //   final drawerFinder = find.byType(Drawer);
  //   expect(drawerFinder, findsOneWidget);
  // });

  testWidgets('Page should have search and watchlist icons in appbar', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState(
      nowPlayingMovies: <Movie>[],
      popularMovies: <Movie>[],
      topRatedMovies: <Movie>[],
    ));

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    final searchIconFinder = find.byIcon(Icons.search);
    final watchlistIconFinder = find.byIcon(Icons.bookmark);

    expect(searchIconFinder, findsOneWidget);
    expect(watchlistIconFinder, findsOneWidget);
  });
}
