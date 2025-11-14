import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/domain/usecases/get_on_the_air_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetOnTheAirTvSeries(mockTvSeriesRepository);
  });

  test('should get list of on the air tv series from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getOnTheAirTvSeries())
        .thenAnswer((_) async => Right(testTvSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvSeriesList));
    verify(mockTvSeriesRepository.getOnTheAirTvSeries());
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
