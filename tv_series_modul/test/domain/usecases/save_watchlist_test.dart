import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/domain/usecases/save_watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlist(mockTvSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    expect(result, const Right('Added to Watchlist'));
    verify(mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
