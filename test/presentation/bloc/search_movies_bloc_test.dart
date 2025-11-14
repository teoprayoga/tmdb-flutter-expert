import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/search_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchMoviesBloc searchMoviesBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMoviesBloc = SearchMoviesBloc(searchMovies: mockSearchMovies);
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
  final tQuery = 'spiderman';

  test('initial state should be Empty', () {
    expect(searchMoviesBloc.state, SearchMoviesEmpty());
  });

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(OnMovieQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      SearchMoviesHasData(tMovieList),
    ],
    verify: (_) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'should emit [Loading, Error] when get search fails',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(OnMovieQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      SearchMoviesError('Server Failure'),
    ],
    verify: (_) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'should emit [Empty] when query is empty',
    build: () => searchMoviesBloc,
    act: (bloc) => bloc.add(OnMovieQueryChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesEmpty(),
    ],
  );
}
