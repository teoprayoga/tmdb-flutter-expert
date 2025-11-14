import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/common/failure.dart';
import 'package:tv_series_modul/domain/entities/tv_series.dart';
import 'package:tv_series_modul/domain/entities/tv_series_detail.dart';
import 'package:tv_series_modul/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series_modul/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series_modul/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series_modul/domain/usecases/remove_watchlist.dart';
import 'package:tv_series_modul/domain/usecases/save_watchlist.dart';
import 'package:tv_series_modul/presentation/bloc/tv_series_detail_bloc.dart';

import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchlistStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    tvSeriesDetailBloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  const tTvSeriesDetail = TvSeriesDetail(
    // adult: false,
    backdropPath: '/path.jpg',
    // episodeRunTime: const [60],
    firstAirDate: '2020-01-01',
    genres: const [],
    // homepage: 'https://example.com',
    id: 1,
    inProduction: false,
    // languages: const ['en'],
    lastAirDate: '2020-12-31',
    name: 'Test TV Series',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originCountry: const ['US'],
    // originalLanguage: 'en',
    // originalName: 'Test TV Series',
    overview: 'Test overview',
    // popularity: 100.0,
    posterPath: '/poster.jpg',
    seasons: const [],
    status: 'Ended',
    // tagline: 'Test tagline',
    type: 'Scripted',
    voteAverage: 8.0,
    voteCount: 1000,
  );

  const tTvSeries = TvSeries(
    // adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2],
    id: 1,
    originCountry: ['US'],
    // originalLanguage: 'en',
    // originalName: 'Test TV Series',
    overview: 'Test overview',
    // popularity: 100.0,
    posterPath: '/poster.jpg',
    firstAirDate: '2020-01-01',
    name: 'Test TV Series',
    voteAverage: 8.0,
    voteCount: 1000,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Initial State', () {
    test('initial state should be correct', () {
      expect(
        tvSeriesDetailBloc.state,
        const TvSeriesDetailState(),
      );
    });
  });

  group('FetchTvSeriesDetail Event', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit loading state and then success state when both detail and recommendations are fetched successfully',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId)).thenAnswer((_) async => Right(tTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          isLoading: true,
          isRecommendationsLoading: true,
        ),
        TvSeriesDetailState(
          isLoading: false,
          isRecommendationsLoading: true,
          tvSeriesDetail: tTvSeriesDetail,
        ),
        TvSeriesDetailState(
          isLoading: false,
          isRecommendationsLoading: false,
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: tTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    // blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    //   'should emit loading state and then error state when fetching detail fails',
    //   build: () {
    //     when(mockGetTvSeriesDetail.execute(tId)).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
    //     when(mockGetTvSeriesRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvSeriesList));
    //     return tvSeriesDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
    //   expect: () => [
    //     const TvSeriesDetailState(
    //       isLoading: true,
    //       isRecommendationsLoading: true,
    //     ),
    //     const TvSeriesDetailState(
    //       isLoading: false,
    //       isRecommendationsLoading: true,
    //       message: 'Server Error',
    //     ),
    //   ],
    //   verify: (_) {
    //     verify(mockGetTvSeriesDetail.execute(tId));
    //     verifyNever(mockGetTvSeriesRecommendations.execute(tId));
    //   },
    // );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit success for detail but error for recommendations when recommendations fail',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId)).thenAnswer((_) async => Right(tTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed to fetch recommendations')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          isLoading: true,
          isRecommendationsLoading: true,
        ),
        TvSeriesDetailState(
          isLoading: false,
          isRecommendationsLoading: true,
          tvSeriesDetail: tTvSeriesDetail,
        ),
        TvSeriesDetailState(
          isLoading: false,
          isRecommendationsLoading: false,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationsMessage: 'Failed to fetch recommendations',
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    // blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    //   'should emit error with ConnectionFailure message',
    //   build: () {
    //     when(mockGetTvSeriesDetail.execute(tId))
    //         .thenAnswer((_) async => const Left(ConnectionFailure('No Internet Connection')));
    //     return tvSeriesDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
    //   expect: () => [
    //     const TvSeriesDetailState(
    //       isLoading: true,
    //       isRecommendationsLoading: true,
    //     ),
    //     const TvSeriesDetailState(
    //       isLoading: false,
    //       isRecommendationsLoading: true,
    //       message: 'No Internet Connection',
    //     ),
    //   ],
    // );

    // blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    //   'should emit error with DatabaseFailure message',
    //   build: () {
    //     when(mockGetTvSeriesDetail.execute(tId)).thenAnswer((_) async => const Left(DatabaseFailure('Database Error')));
    //     return tvSeriesDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
    //   expect: () => [
    //     const TvSeriesDetailState(
    //       isLoading: true,
    //       isRecommendationsLoading: true,
    //     ),
    //     const TvSeriesDetailState(
    //       isLoading: false,
    //       isRecommendationsLoading: true,
    //       message: 'Database Error',
    //     ),
    //   ],
    // );
  });

  group('AddToWatchlist Event', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit watchlist added state when adding to watchlist is successful',
      build: () {
        when(mockSaveWatchlist.execute(tTvSeriesDetail)).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
        const TvSeriesDetailState(
          watchlistMessage: '',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit error message when adding to watchlist fails',
      build: () {
        when(mockSaveWatchlist.execute(tTvSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed to save')));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Failed to save',
        ),
        const TvSeriesDetailState(
          watchlistMessage: '',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });

  group('RemoveFromWatchlist Event', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit watchlist removed state when removing from watchlist is successful',
      build: () {
        when(mockRemoveWatchlist.execute(tTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
        const TvSeriesDetailState(
          watchlistMessage: '',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(tTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit error message when removing from watchlist fails',
      build: () {
        when(mockRemoveWatchlist.execute(tTvSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed to remove')));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Failed to remove',
        ),
        const TvSeriesDetailState(
          watchlistMessage: '',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(tTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });

  group('LoadWatchlistStatus Event', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit watchlist status true when TV series is in watchlist',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TvSeriesDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: '',
        ),
      ],
      verify: (_) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit watchlist status false when TV series is not in watchlist',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TvSeriesDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      ],
      verify: (_) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });

  group('State copyWith method', () {
    test('should return same state when no parameters are provided', () {
      const state = TvSeriesDetailState();
      final newState = state.copyWith();
      expect(newState, state);
    });

    test('should update only the provided parameters', () {
      const state = TvSeriesDetailState();
      final newState = state.copyWith(
        isLoading: true,
        message: 'Error',
        isAddedToWatchlist: true,
      );

      expect(newState.isLoading, true);
      expect(newState.message, 'Error');
      expect(newState.isAddedToWatchlist, true);
      expect(newState.recommendations, state.recommendations);
      expect(newState.tvSeriesDetail, state.tvSeriesDetail);
    });

    test('should preserve existing values when null is passed', () {
      final state = TvSeriesDetailState(
        tvSeriesDetail: tTvSeriesDetail,
        recommendations: tTvSeriesList,
        isLoading: true,
        message: 'Original message',
      );

      final newState = state.copyWith(
        tvSeriesDetail: null,
        recommendations: null,
        isLoading: null,
        message: null,
      );

      expect(newState.tvSeriesDetail, tTvSeriesDetail);
      expect(newState.recommendations, tTvSeriesList);
      expect(newState.isLoading, true);
      expect(newState.message, 'Original message');
    });
  });

  group('Event props', () {
    test('FetchTvSeriesDetail props should contain id', () {
      const event = FetchTvSeriesDetail(1);
      expect(event.props, [1]);
    });

    test('AddToWatchlist props should contain tvSeries', () {
      final event = AddToWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
    });

    test('RemoveFromWatchlist props should contain tvSeries', () {
      final event = RemoveFromWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
    });

    test('LoadWatchlistStatus props should contain id', () {
      const event = LoadWatchlistStatus(1);
      expect(event.props, [1]);
    });

    test('TvSeriesDetailEvent base props should be empty', () {
      // Create a concrete implementation to test the abstract class
      const TestEvent event = TestEvent();
      expect(event.props, []);
    });
  });

  group('State props', () {
    test('should return correct props list', () {
      final state = TvSeriesDetailState(
        tvSeriesDetail: tTvSeriesDetail,
        recommendations: tTvSeriesList,
        isLoading: true,
        isRecommendationsLoading: true,
        message: 'Error',
        recommendationsMessage: 'Rec Error',
        isAddedToWatchlist: true,
        watchlistMessage: 'Watchlist Error',
      );

      expect(
        state.props,
        [
          tTvSeriesDetail,
          tTvSeriesList,
          true,
          true,
          'Error',
          'Rec Error',
          true,
          'Watchlist Error',
        ],
      );
    });

    test('should be equal when props are equal', () {
      const state1 = TvSeriesDetailState(
        isLoading: true,
        message: 'Test',
      );
      const state2 = TvSeriesDetailState(
        isLoading: true,
        message: 'Test',
      );

      expect(state1, equals(state2));
    });

    test('should not be equal when props are different', () {
      const state1 = TvSeriesDetailState(
        isLoading: true,
        message: 'Test1',
      );
      const state2 = TvSeriesDetailState(
        isLoading: true,
        message: 'Test2',
      );

      expect(state1, isNot(equals(state2)));
    });
  });

  group('Edge Cases', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should handle multiple rapid FetchTvSeriesDetail calls',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId)).thenAnswer((_) async => Right(tTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesDetailBloc;
      },
      act: (bloc) {
        bloc.add(const FetchTvSeriesDetail(tId));
        bloc.add(const FetchTvSeriesDetail(tId));
      },
      skip: 0,
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId)).called(2);
        verify(mockGetTvSeriesRecommendations.execute(tId)).called(2);
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should handle AddToWatchlist followed by RemoveFromWatchlist',
      build: () {
        when(mockSaveWatchlist.execute(tTvSeriesDetail)).thenAnswer((_) async => const Right('Added'));
        when(mockRemoveWatchlist.execute(tTvSeriesDetail)).thenAnswer((_) async => const Right('Removed'));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) {
        bloc.add(AddToWatchlist(tTvSeriesDetail));
        bloc.add(RemoveFromWatchlist(tTvSeriesDetail));
      },
      skip: 0,
      verify: (_) {
        verify(mockSaveWatchlist.execute(tTvSeriesDetail));
        verify(mockRemoveWatchlist.execute(tTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(tId)).called(2);
      },
    );
  });
}

// Test helper class for testing abstract event
class TestEvent extends TvSeriesDetailEvent {
  const TestEvent();
}
