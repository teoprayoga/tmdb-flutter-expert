import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/common/failure.dart';
import 'package:tv_series_modul/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series_modul/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series_modul/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series_modul/domain/usecases/remove_watchlist.dart';
import 'package:tv_series_modul/domain/usecases/save_watchlist.dart';
import 'package:tv_series_modul/presentation/bloc/tv_series_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
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

  test('initial state should be empty', () {
    expect(tvSeriesDetailBloc.state, const TvSeriesDetailState());
  });

  group('Fetch TV Series Detail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, HasData] when detail and recommendations are gotten successfully',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          isLoading: true,
          isRecommendationsLoading: true,
        ),
        const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          isRecommendationsLoading: true,
        ),
        TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          isRecommendationsLoading: false,
          recommendations: testTvSeriesList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          isLoading: true,
          isRecommendationsLoading: true,
        ),
        const TvSeriesDetailState(
          isLoading: false,
          message: 'Server Failure',
          isRecommendationsLoading: true,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, HasData with recommendations error] when detail is successful but recommendations fail',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          isLoading: true,
          isRecommendationsLoading: true,
        ),
        const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          isRecommendationsLoading: true,
        ),
        const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          isRecommendationsLoading: false,
          recommendationsMessage: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );
  });

  group('Add To Watchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit success message and trigger LoadWatchlistStatus when add is successful',
      build: () {
        when(mockSaveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
        const TvSeriesDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit error message when add is unsuccessful',
      build: () {
        when(mockSaveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Database Failure',
        ),
        const TvSeriesDetailState(
          watchlistMessage: 'Database Failure',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(testTvSeriesDetail.id));
      },
    );
  });

  group('Remove From Watchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit success message and trigger LoadWatchlistStatus when remove is successful',
      build: () {
        when(mockRemoveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
        const TvSeriesDetailState(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit error message when remove is unsuccessful',
      build: () {
        when(mockRemoveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Database Failure',
        ),
        const TvSeriesDetailState(
          watchlistMessage: 'Database Failure',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatus.execute(testTvSeriesDetail.id));
      },
    );
  });

  group('Load Watchlist Status', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit true when tv series is in watchlist',
      build: () {
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TvSeriesDetailState(isAddedToWatchlist: true),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit false when tv series is not in watchlist',
      build: () {
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TvSeriesDetailState(isAddedToWatchlist: false),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });
}
