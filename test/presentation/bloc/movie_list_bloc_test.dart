import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

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

  group('Initial State', () {
    test('initial state should be empty', () {
      expect(movieListBloc.state, const MovieListState());
    });

    test('initial state should have correct default values', () {
      final state = movieListBloc.state;
      expect(state.nowPlayingMovies, []);
      expect(state.popularMovies, []);
      expect(state.topRatedMovies, []);
      expect(state.nowPlayingMessage, '');
      expect(state.popularMessage, '');
      expect(state.topRatedMessage, '');
      expect(state.isNowPlayingLoading, false);
      expect(state.isPopularLoading, false);
      expect(state.isTopRatedLoading, false);
    });
  });

  group('FetchNowPlayingMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(isNowPlayingLoading: true),
        MovieListState(
          isNowPlayingLoading: false,
          nowPlayingMovies: tMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when get data fails',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(isNowPlayingLoading: true),
        const MovieListState(
          isNowPlayingLoading: false,
          nowPlayingMessage: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('FetchPopularMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(isPopularLoading: true),
        MovieListState(
          isPopularLoading: false,
          popularMovies: tMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when get data fails',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(isPopularLoading: true),
        const MovieListState(
          isPopularLoading: false,
          popularMessage: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('FetchTopRatedMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(isTopRatedLoading: true),
        MovieListState(
          isTopRatedLoading: false,
          topRatedMovies: tMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when get data fails',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(isTopRatedLoading: true),
        const MovieListState(
          isTopRatedLoading: false,
          topRatedMessage: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
