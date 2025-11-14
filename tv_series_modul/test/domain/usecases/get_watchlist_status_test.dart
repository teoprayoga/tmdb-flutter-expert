import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/domain/usecases/get_watchlist_status.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistStatus usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchlistStatus(mockTvSeriesRepository);
  });

  const tId = 1;

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockTvSeriesRepository.isAddedToWatchlist(tId))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, true);
    verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });

  test('should return false when tv series is not in watchlist', () async {
    // arrange
    when(mockTvSeriesRepository.isAddedToWatchlist(tId))
        .thenAnswer((_) async => false);
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, false);
    verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
