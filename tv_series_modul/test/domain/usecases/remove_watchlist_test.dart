import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/domain/usecases/remove_watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlist(mockTvSeriesRepository);
  });

  test('should remove tv series from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    expect(result, const Right('Removed from Watchlist'));
    verify(mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
