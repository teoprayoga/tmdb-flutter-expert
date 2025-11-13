import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/common/exception.dart';
import 'package:tv_series_modul/data/datasources/db/database_helper.dart';
import 'package:tv_series_modul/data/datasources/tv_series_local_data_source.dart';
import 'package:tv_series_modul/data/models/tv_series_table.dart';

import 'tv_series_local_data_source_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('insertWatchlist', () {
    final tTvSeriesTable = TvSeriesTable(
      id: 1,
      name: 'Breaking Bad',
      overview: 'Overview',
      posterPath: '/poster.jpg',
    );

    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(tTvSeriesTable))
          .thenAnswer((_) async => 1);

      // act
      final result = await dataSource.insertWatchlist(tTvSeriesTable);

      // assert
      verify(mockDatabaseHelper.insertWatchlist(tTvSeriesTable));
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(tTvSeriesTable))
          .thenThrow(Exception('Failed to insert'));

      // act
      final call = dataSource.insertWatchlist(tTvSeriesTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('removeWatchlist', () {
    final tTvSeriesTable = TvSeriesTable(
      id: 1,
      name: 'Breaking Bad',
      overview: 'Overview',
      posterPath: '/poster.jpg',
    );

    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(tTvSeriesTable))
          .thenAnswer((_) async => 1);

      // act
      final result = await dataSource.removeWatchlist(tTvSeriesTable);

      // assert
      verify(mockDatabaseHelper.removeWatchlist(tTvSeriesTable));
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(tTvSeriesTable))
          .thenThrow(Exception('Failed to remove'));

      // act
      final call = dataSource.removeWatchlist(tTvSeriesTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('getTvSeriesById', () {
    const tId = 1;
    final tTvSeriesMap = {
      'id': 1,
      'name': 'Breaking Bad',
      'overview': 'Overview',
      'posterPath': '/poster.jpg',
    };

    test('should return TvSeriesTable when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId))
          .thenAnswer((_) async => tTvSeriesMap);

      // act
      final result = await dataSource.getTvSeriesById(tId);

      // assert
      verify(mockDatabaseHelper.getTvSeriesById(tId));
      expect(result, isA<TvSeriesTable>());
      expect(result?.id, 1);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId))
          .thenAnswer((_) async => null);

      // act
      final result = await dataSource.getTvSeriesById(tId);

      // assert
      verify(mockDatabaseHelper.getTvSeriesById(tId));
      expect(result, null);
    });
  });

  group('getWatchlistTvSeries', () {
    final tTvSeriesMapList = [
      {
        'id': 1,
        'name': 'Breaking Bad',
        'overview': 'Overview',
        'posterPath': '/poster.jpg',
      },
      {
        'id': 2,
        'name': 'Game of Thrones',
        'overview': 'Overview 2',
        'posterPath': '/poster2.jpg',
      },
    ];

    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenAnswer((_) async => tTvSeriesMapList);

      // act
      final result = await dataSource.getWatchlistTvSeries();

      // assert
      verify(mockDatabaseHelper.getWatchlistTvSeries());
      expect(result, isA<List<TvSeriesTable>>());
      expect(result.length, 2);
    });

    test('should return empty list when no watchlist data', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenAnswer((_) async => []);

      // act
      final result = await dataSource.getWatchlistTvSeries();

      // assert
      verify(mockDatabaseHelper.getWatchlistTvSeries());
      expect(result, []);
    });
  });
}
