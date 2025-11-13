import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/common/failure.dart';
import 'package:ditonton_tv_series/presentation/bloc/tv_series_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton_tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton_tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton_tv_series/domain/usecases/get_on_the_air_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
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

  test('initial state should be empty', () {
    expect(tvSeriesListBloc.state, const TvSeriesListState());
  });

  blocTest<TvSeriesListBloc, TvSeriesListState>(
    'should emit [Loading, HasData] when popular tv series data is gotten successfully',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
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
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    },
  );

  blocTest<TvSeriesListBloc, TvSeriesListState>(
    'should emit [Loading, Error] when get popular tv series is unsuccessful',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
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
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    },
  );
}
