import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;

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

  final tMovies = <Movie>[tMovie];

  group('Get Movie Detail', () {
    // blocTest<MovieDetailBloc, MovieDetailState>(
    //   'should emit [Loading, HasData] when data is gotten successfully',
    //   build: () {
    //     when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
    //     when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
    //     return movieDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    //   expect: () => [
    //     const MovieDetailState(isLoading: true, isRecommendationsLoading: true),
    //     MovieDetailState(
    //       isLoading: false,
    //       movieDetail: testMovieDetail,
    //       isRecommendationsLoading: false,
    //       recommendations: tMovies,
    //     ),
    //   ],
    //   verify: (_) {
    //     verify(mockGetMovieDetail.execute(tId));
    //     verify(mockGetMovieRecommendations.execute(tId));
    //   },
    // );

    // blocTest<MovieDetailBloc, MovieDetailState>(
    //   'should emit [Loading, Error] when get detail fails',
    //   build: () {
    //     when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    //     when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
    //     return movieDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    //   expect: () => [
    //     const MovieDetailState(isLoading: true, isRecommendationsLoading: true),
    //     const MovieDetailState(
    //       isLoading: false,
    //       message: 'Server Failure',
    //     ),
    //   ],
    //   verify: (_) {
    //     verify(mockGetMovieDetail.execute(tId));
    //   },
    // );
  });

  group('Get Movie Recommendations', () {
    // blocTest<MovieDetailBloc, MovieDetailState>(
    //   'should emit recommendations when get recommendations succeeds',
    //   build: () {
    //     when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
    //     when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
    //     return movieDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    //   expect: () => [
    //     const MovieDetailState(isLoading: true, isRecommendationsLoading: true),
    //     MovieDetailState(
    //       isLoading: false,
    //       movieDetail: testMovieDetail,
    //       isRecommendationsLoading: false,
    //       recommendations: tMovies,
    //     ),
    //   ],
    // );

    // blocTest<MovieDetailBloc, MovieDetailState>(
    //   'should emit error message when get recommendations fails',
    //   build: () {
    //     when(mockGetMovieDetail.execute(tId))
    //         .thenAnswer((_) async => Right(testMovieDetail));
    //     when(mockGetMovieRecommendations.execute(tId))
    //         .thenAnswer((_) async => Left(ServerFailure('Failed')));
    //     return movieDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    //   expect: () => [
    //     const MovieDetailState(isLoading: true, isRecommendationsLoading: true),
    //     MovieDetailState(
    //       isLoading: false,
    //       movieDetail: testMovieDetail,
    //       isRecommendationsLoading: false,
    //       recommendationsMessage: 'Failed',
    //     ),
    //   ],
    // );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should get watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(LoadMovieWatchlistStatus(tId)),
      expect: () => [
        const MovieDetailState(isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
        const MovieDetailState(
          watchlistMessage: '',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
        const MovieDetailState(
          watchlistMessage: '',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should update watchlist message when add watchlist fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Failed'),
        const MovieDetailState(
          watchlistMessage: '',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );
  });
}
