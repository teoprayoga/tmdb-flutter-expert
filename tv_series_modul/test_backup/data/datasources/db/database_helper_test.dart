import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tv_series_modul/data/datasources/db/database_helper.dart';
import 'package:tv_series_modul/data/models/tv_series_table.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = DatabaseHelper();
  });

  tearDown(() async {
    // Membersihkan data setelah setiap tes selesai
    final db = await databaseHelper.database;
    await db!.delete('watchlist'); // Ganti 'watchlist' dengan nama tabel Anda jika berbeda
  });

  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'Breaking Bad',
    overview: 'A high school chemistry teacher',
    posterPath: '/poster.jpg',
  );

  group('insertWatchlist', () {
    test('should return watchlist id when insert is success', () async {
      // act
      final result = await databaseHelper.insertWatchlist(tTvSeriesTable);

      // assert
      expect(result, result);
    });
  });

  group('removeWatchlist', () {
    test('should return success when remove watchlist is success', () async {
      // arrange
      await databaseHelper.insertWatchlist(tTvSeriesTable);

      // act
      final result = await databaseHelper.removeWatchlist(tTvSeriesTable);

      // assert
      expect(result, 1);
    });

    test('should return 0 when remove non-existent watchlist', () async {
      // act
      final result = await databaseHelper.removeWatchlist(tTvSeriesTable);

      // assert
      expect(result, 0);
    });
  });

  group('getTvSeriesById', () {
    test('should return tv series map when data exists', () async {
      // arrange
      await databaseHelper.insertWatchlist(tTvSeriesTable);

      // act
      final result = await databaseHelper.getTvSeriesById(1);

      // assert
      expect(result, isNotNull);
      expect(result?['id'], 1);
      expect(result?['name'], 'Breaking Bad');
    });

    test('should return null when data does not exist', () async {
      // act
      final result = await databaseHelper.getTvSeriesById(999);

      // assert
      expect(result, null);
    });
  });

  group('getWatchlistTvSeries', () {
    test('should return list of tv series map when data exists', () async {
      // arrange
      await databaseHelper.insertWatchlist(tTvSeriesTable);
      final tTvSeriesTable2 = TvSeriesTable(
        id: 2,
        name: 'Game of Thrones',
        overview: 'Epic fantasy series',
        posterPath: '/poster2.jpg',
      );
      await databaseHelper.insertWatchlist(tTvSeriesTable2);

      // act
      final result = await databaseHelper.getWatchlistTvSeries();

      // assert
      expect(result.length, 2);
      expect(result[0]['id'], 1);
      expect(result[1]['id'], 2);
    });

    test('should return empty list when no data exists', () async {
      // act
      final result = await databaseHelper.getWatchlistTvSeries();

      // assert
      expect(result, []);
    });
  });
}
