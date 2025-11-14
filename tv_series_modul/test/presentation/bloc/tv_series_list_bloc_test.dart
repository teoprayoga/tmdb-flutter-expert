import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/common/failure.dart';
import 'package:tv_series_modul/domain/entities/tv_series.dart';
import 'package:tv_series_modul/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:tv_series_modul/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series_modul/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series_modul/presentation/bloc/tv_series_list_bloc.dart';

import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetPopularTvSeries,
  GetTopRatedTvSeries,
  GetOnTheAirTvSeries,
])
void main() {
  late TvSeriesListBloc tvSeriesListBloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;

  // Test data
  final tTvSeries = TvSeries(
    // adult: false,
    backdropPath: '/path.jpg',
    genreIds: const [1, 2],
    id: 1,
    originCountry: const ['US'],
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

  final tTvSeries2 = TvSeries(
    // adult: false,
    backdropPath: '/path2.jpg',
    genreIds: const [3, 4],
    id: 2,
    originCountry: const ['UK'],
    // originalLanguage: 'en',
    // originalName: 'Test TV Series 2',
    overview: 'Test overview 2',
    // popularity: 90.0,
    posterPath: '/poster2.jpg',
    firstAirDate: '2021-01-01',
    name: 'Test TV Series 2',
    voteAverage: 7.5,
    voteCount: 800,
  );

  final testTvSeriesList = <TvSeries>[tTvSeries];
  final testTvSeriesList2 = <TvSeries>[tTvSeries2];
  final testMultipleTvSeriesList = <TvSeries>[tTvSeries, tTvSeries2];

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    tvSeriesListBloc = TvSeriesListBloc(
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
      getOnTheAirTvSeries: mockGetOnTheAirTvSeries,
    );
  });

  group('Initial State', () {
    test('initial state should be empty', () {
      expect(tvSeriesListBloc.state, const TvSeriesListState());
    });

    test('initial state should have correct default values', () {
      final state = tvSeriesListBloc.state;
      expect(state.popularTvSeries, []);
      expect(state.topRatedTvSeries, []);
      expect(state.onTheAirTvSeries, []);
      expect(state.popularMessage, '');
      expect(state.topRatedMessage, '');
      expect(state.onTheAirMessage, '');
      expect(state.isPopularLoading, false);
      expect(state.isTopRatedLoading, false);
      expect(state.isOnTheAirLoading, false);
    });
  });

  group('FetchPopularTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, HasData] when popular tv series data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(isPopularLoading: true),
        TvSeriesListState(
          isPopularLoading: false,
          popularTvSeries: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockGetPopularTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] when get popular tv series fails with ServerFailure',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(isPopularLoading: true),
        const TvSeriesListState(
          isPopularLoading: false,
          popularMessage: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetPopularTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] with ConnectionFailure message',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => const Left(ConnectionFailure('No Internet Connection')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(isPopularLoading: true),
        const TvSeriesListState(
          isPopularLoading: false,
          popularMessage: 'No Internet Connection',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] with DatabaseFailure message',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => const Left(DatabaseFailure('Database Error')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(isPopularLoading: true),
        const TvSeriesListState(
          isPopularLoading: false,
          popularMessage: 'Database Error',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle empty list result',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => const Right([]));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(isPopularLoading: true),
        const TvSeriesListState(
          isPopularLoading: false,
          popularTvSeries: [],
        ),
      ],
    );
  });

  group('FetchTopRatedTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, HasData] when top rated tv series data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(isTopRatedLoading: true),
        TvSeriesListState(
          isTopRatedLoading: false,
          topRatedTvSeries: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] when get top rated tv series fails',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Failed to fetch top rated')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(isTopRatedLoading: true),
        const TvSeriesListState(
          isTopRatedLoading: false,
          topRatedMessage: 'Failed to fetch top rated',
        ),
      ],
      verify: (_) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle multiple items in top rated list',
      build: () {
        when(mockGetTopRatedTvSeries.execute()).thenAnswer((_) async => Right(testMultipleTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(isTopRatedLoading: true),
        TvSeriesListState(
          isTopRatedLoading: false,
          topRatedTvSeries: testMultipleTvSeriesList,
        ),
      ],
    );
  });

  group('FetchOnTheAirTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, HasData] when on the air tv series data is gotten successfully',
      build: () {
        when(mockGetOnTheAirTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
      expect: () => [
        const TvSeriesListState(isOnTheAirLoading: true),
        TvSeriesListState(
          isOnTheAirLoading: false,
          onTheAirTvSeries: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockGetOnTheAirTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] when get on the air tv series fails',
      build: () {
        when(mockGetOnTheAirTvSeries.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Failed to fetch on the air')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
      expect: () => [
        const TvSeriesListState(isOnTheAirLoading: true),
        const TvSeriesListState(
          isOnTheAirLoading: false,
          onTheAirMessage: 'Failed to fetch on the air',
        ),
      ],
      verify: (_) {
        verify(mockGetOnTheAirTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle ConnectionFailure for on the air',
      build: () {
        when(mockGetOnTheAirTvSeries.execute())
            .thenAnswer((_) async => const Left(ConnectionFailure('Connection lost')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
      expect: () => [
        const TvSeriesListState(isOnTheAirLoading: true),
        const TvSeriesListState(
          isOnTheAirLoading: false,
          onTheAirMessage: 'Connection lost',
        ),
      ],
    );
  });

  group('Multiple Concurrent Events', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle multiple events simultaneously',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        when(mockGetTopRatedTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList2));
        when(mockGetOnTheAirTvSeries.execute()).thenAnswer((_) async => Right(testMultipleTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
        bloc.add(FetchTopRatedTvSeries());
        bloc.add(FetchOnTheAirTvSeries());
      },
      skip: 0,
      verify: (_) {
        verify(mockGetPopularTvSeries.execute()).called(1);
        verify(mockGetTopRatedTvSeries.execute()).called(1);
        verify(mockGetOnTheAirTvSeries.execute()).called(1);
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should preserve other states when one event is processed',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        when(mockGetTopRatedTvSeries.execute()).thenAnswer((_) async => const Left(ServerFailure('Error')));
        return tvSeriesListBloc;
      },
      seed: () => TvSeriesListState(
        onTheAirTvSeries: testMultipleTvSeriesList,
        onTheAirMessage: 'Previous message',
      ),
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
        bloc.add(FetchTopRatedTvSeries());
      },
      skip: 0,
      verify: (bloc) {
        // Final state should preserve onTheAir data
        final finalState = bloc.state;
        expect(finalState.onTheAirTvSeries, testMultipleTvSeriesList);
        expect(finalState.popularTvSeries, testTvSeriesList);
        expect(finalState.topRatedMessage, 'Error');
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle mixed success and failure results',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        when(mockGetTopRatedTvSeries.execute()).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        when(mockGetOnTheAirTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList2));
        return tvSeriesListBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
        bloc.add(FetchTopRatedTvSeries());
        bloc.add(FetchOnTheAirTvSeries());
      },
      skip: 0,
      verify: (bloc) {
        final state = bloc.state;
        expect(state.popularTvSeries, testTvSeriesList);
        expect(state.topRatedMessage, 'Server Error');
        expect(state.onTheAirTvSeries, testTvSeriesList2);
      },
    );
  });

  group('State copyWith method', () {
    test('should return same state when no parameters are provided', () {
      const state = TvSeriesListState();
      final newState = state.copyWith();
      expect(newState, state);
    });

    test('should update only the provided parameters', () {
      const state = TvSeriesListState();
      final newState = state.copyWith(
        popularTvSeries: testTvSeriesList,
        isPopularLoading: true,
        topRatedMessage: 'Error',
      );

      expect(newState.popularTvSeries, testTvSeriesList);
      expect(newState.isPopularLoading, true);
      expect(newState.topRatedMessage, 'Error');
      // Other values should remain default
      expect(newState.topRatedTvSeries, []);
      expect(newState.onTheAirTvSeries, []);
      expect(newState.popularMessage, '');
    });

    test('should preserve existing values when null is passed', () {
      final state = TvSeriesListState(
        popularTvSeries: testTvSeriesList,
        topRatedTvSeries: testTvSeriesList2,
        onTheAirTvSeries: testMultipleTvSeriesList,
        popularMessage: 'Popular Error',
        topRatedMessage: 'Top Rated Error',
        onTheAirMessage: 'On Air Error',
        isPopularLoading: true,
        isTopRatedLoading: true,
        isOnTheAirLoading: true,
      );

      final newState = state.copyWith(
        popularTvSeries: null,
        topRatedTvSeries: null,
        onTheAirTvSeries: null,
        popularMessage: null,
        topRatedMessage: null,
        onTheAirMessage: null,
        isPopularLoading: null,
        isTopRatedLoading: null,
        isOnTheAirLoading: null,
      );

      expect(newState.popularTvSeries, testTvSeriesList);
      expect(newState.topRatedTvSeries, testTvSeriesList2);
      expect(newState.onTheAirTvSeries, testMultipleTvSeriesList);
      expect(newState.popularMessage, 'Popular Error');
      expect(newState.topRatedMessage, 'Top Rated Error');
      expect(newState.onTheAirMessage, 'On Air Error');
      expect(newState.isPopularLoading, true);
      expect(newState.isTopRatedLoading, true);
      expect(newState.isOnTheAirLoading, true);
    });

    test('should update multiple parameters at once', () {
      const state = TvSeriesListState();
      final newState = state.copyWith(
        popularTvSeries: testTvSeriesList,
        topRatedTvSeries: testTvSeriesList2,
        onTheAirTvSeries: testMultipleTvSeriesList,
        isPopularLoading: false,
        isTopRatedLoading: true,
        isOnTheAirLoading: false,
      );

      expect(newState.popularTvSeries, testTvSeriesList);
      expect(newState.topRatedTvSeries, testTvSeriesList2);
      expect(newState.onTheAirTvSeries, testMultipleTvSeriesList);
      expect(newState.isPopularLoading, false);
      expect(newState.isTopRatedLoading, true);
      expect(newState.isOnTheAirLoading, false);
    });
  });

  group('Event props', () {
    test('FetchPopularTvSeries props should be empty', () {
      final event = FetchPopularTvSeries();
      expect(event.props, []);
    });

    test('FetchTopRatedTvSeries props should be empty', () {
      final event = FetchTopRatedTvSeries();
      expect(event.props, []);
    });

    test('FetchOnTheAirTvSeries props should be empty', () {
      final event = FetchOnTheAirTvSeries();
      expect(event.props, []);
    });

    test('Events should be equal when they are the same type', () {
      final event1 = FetchPopularTvSeries();
      final event2 = FetchPopularTvSeries();
      expect(event1, equals(event2));
    });

    test('Different events should not be equal', () {
      final event1 = FetchPopularTvSeries();
      final event2 = FetchTopRatedTvSeries();
      expect(event1, isNot(equals(event2)));
    });
  });

  group('State props', () {
    test('should return correct props list', () {
      final state = TvSeriesListState(
        popularTvSeries: testTvSeriesList,
        topRatedTvSeries: testTvSeriesList2,
        onTheAirTvSeries: testMultipleTvSeriesList,
        popularMessage: 'Popular Error',
        topRatedMessage: 'Top Error',
        onTheAirMessage: 'On Air Error',
        isPopularLoading: true,
        isTopRatedLoading: false,
        isOnTheAirLoading: true,
      );

      expect(
        state.props,
        [
          testTvSeriesList,
          testTvSeriesList2,
          testMultipleTvSeriesList,
          'Popular Error',
          'Top Error',
          'On Air Error',
          true,
          false,
          true,
        ],
      );
    });

    test('should be equal when props are equal', () {
      final state1 = TvSeriesListState(
        popularTvSeries: testTvSeriesList,
        isPopularLoading: true,
        popularMessage: 'Test',
      );
      final state2 = TvSeriesListState(
        popularTvSeries: testTvSeriesList,
        isPopularLoading: true,
        popularMessage: 'Test',
      );

      expect(state1, equals(state2));
    });

    test('should not be equal when props are different', () {
      final state1 = TvSeriesListState(
        popularTvSeries: testTvSeriesList,
        isPopularLoading: true,
      );
      final state2 = TvSeriesListState(
        popularTvSeries: testTvSeriesList,
        isPopularLoading: false,
      );

      expect(state1, isNot(equals(state2)));
    });
  });

  group('Edge Cases', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle rapid successive calls to same event',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
        bloc.add(FetchPopularTvSeries());
        bloc.add(FetchPopularTvSeries());
      },
      skip: 0,
      verify: (_) {
        verify(mockGetPopularTvSeries.execute()).called(3);
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle all events failing',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => const Left(ServerFailure('Popular Failed')));
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => const Left(ConnectionFailure('TopRated Failed')));
        when(mockGetOnTheAirTvSeries.execute()).thenAnswer((_) async => const Left(DatabaseFailure('OnTheAir Failed')));
        return tvSeriesListBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
        bloc.add(FetchTopRatedTvSeries());
        bloc.add(FetchOnTheAirTvSeries());
      },
      skip: 0,
      verify: (bloc) {
        final state = bloc.state;
        expect(state.popularMessage, 'Popular Failed');
        expect(state.topRatedMessage, 'TopRated Failed');
        expect(state.onTheAirMessage, 'OnTheAir Failed');
        expect(state.popularTvSeries, []);
        expect(state.topRatedTvSeries, []);
        expect(state.onTheAirTvSeries, []);
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should clear previous error message when fetching successfully',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => Right(testTvSeriesList));
        return tvSeriesListBloc;
      },
      seed: () => const TvSeriesListState(
        popularMessage: 'Previous Error',
      ),
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(
          popularMessage: 'Previous Error',
          isPopularLoading: true,
        ),
        TvSeriesListState(
          isPopularLoading: false,
          popularTvSeries: testTvSeriesList,
          popularMessage: 'Previous Error', // Message is preserved in copyWith
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should clear previous data when fetching fails',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => const Left(ServerFailure('New Error')));
        return tvSeriesListBloc;
      },
      seed: () => TvSeriesListState(
        popularTvSeries: testTvSeriesList,
      ),
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        TvSeriesListState(
          popularTvSeries: testTvSeriesList,
          isPopularLoading: true,
        ),
        TvSeriesListState(
          popularTvSeries: testTvSeriesList, // Data is preserved in copyWith
          isPopularLoading: false,
          popularMessage: 'New Error',
        ),
      ],
    );
  });

  group('Integration Tests', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should handle complete flow with all three categories',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(testTvSeriesList);
        });
        when(mockGetTopRatedTvSeries.execute()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return Right(testTvSeriesList2);
        });
        when(mockGetOnTheAirTvSeries.execute()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 150));
          return Right(testMultipleTvSeriesList);
        });
        return tvSeriesListBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
        bloc.add(FetchTopRatedTvSeries());
        bloc.add(FetchOnTheAirTvSeries());
      },
      wait: const Duration(milliseconds: 200),
      verify: (bloc) {
        final state = bloc.state;
        expect(state.popularTvSeries, testTvSeriesList);
        expect(state.topRatedTvSeries, testTvSeriesList2);
        expect(state.onTheAirTvSeries, testMultipleTvSeriesList);
        expect(state.isPopularLoading, false);
        expect(state.isTopRatedLoading, false);
        expect(state.isOnTheAirLoading, false);
      },
    );
  });
}
