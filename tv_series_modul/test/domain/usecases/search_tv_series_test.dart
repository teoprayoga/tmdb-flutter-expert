import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/domain/usecases/search_tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockTvSeriesRepository);
  });

  const tQuery = 'Breaking Bad';

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(testTvSeriesList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(testTvSeriesList));
    verify(mockTvSeriesRepository.searchTvSeries(tQuery));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
