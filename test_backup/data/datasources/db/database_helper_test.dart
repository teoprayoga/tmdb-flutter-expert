import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper databaseHelper;

  // Setup sqflite_ffi for testing
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory for unit testing
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Get the singleton instance
    databaseHelper = DatabaseHelper();

    // Clear any existing data
    final db = await databaseHelper.database;
    if (db != null) {
      await db.delete('watchlist');
    }
  });

  group('DatabaseHelper Tests', () {
    final testMovieTable = MovieTable(
      id: 1,
      title: 'Test Movie',
      posterPath: '/test.jpg',
      overview: 'Test Overview',
    );

    final testMovieTable2 = MovieTable(
      id: 2,
      title: 'Test Movie 2',
      posterPath: '/test2.jpg',
      overview: 'Test Overview 2',
    );

    test('should return singleton instance', () {
      // arrange
      final instance1 = DatabaseHelper();
      final instance2 = DatabaseHelper();

      // assert
      expect(instance1, equals(instance2));
    });

    test('should initialize database successfully', () async {
      // act
      final db = await databaseHelper.database;

      // assert
      expect(db, isNotNull);
      expect(db is Database, true);
    });

    test('should return same database instance on multiple calls', () async {
      // act
      final db1 = await databaseHelper.database;
      final db2 = await databaseHelper.database;

      // assert
      expect(db1, equals(db2));
    });

    test('should create watchlist table with correct schema', () async {
      // act
      final db = await databaseHelper.database;
      final tables = await db!.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='watchlist'",
      );

      // assert
      expect(tables.isNotEmpty, true);
      expect(tables.first['name'], 'watchlist');
    });

    test('should insert movie to watchlist successfully', () async {
      // act
      final result = await databaseHelper.insertWatchlist(testMovieTable);

      // assert
      expect(result, greaterThan(0));

      // verify insertion
      final movie = await databaseHelper.getMovieById(1);
      expect(movie, isNotNull);
      expect(movie!['id'], testMovieTable.id);
      expect(movie['title'], testMovieTable.title);
    });

    test('should insert multiple movies to watchlist', () async {
      // act
      await databaseHelper.insertWatchlist(testMovieTable);
      await databaseHelper.insertWatchlist(testMovieTable2);

      // assert
      final movies = await databaseHelper.getWatchlistMovies();
      expect(movies.length, 2);
    });

    test('should get movie by id successfully', () async {
      // arrange
      await databaseHelper.insertWatchlist(testMovieTable);

      // act
      final result = await databaseHelper.getMovieById(1);

      // assert
      expect(result, isNotNull);
      expect(result!['id'], 1);
      expect(result['title'], 'Test Movie');
      expect(result['overview'], 'Test Overview');
      expect(result['posterPath'], '/test.jpg');
    });

    test('should return null when movie not found by id', () async {
      // act
      final result = await databaseHelper.getMovieById(999);

      // assert
      expect(result, isNull);
    });

    test('should get all watchlist movies successfully', () async {
      // arrange
      await databaseHelper.insertWatchlist(testMovieTable);
      await databaseHelper.insertWatchlist(testMovieTable2);

      // act
      final result = await databaseHelper.getWatchlistMovies();

      // assert
      expect(result.length, 2);
      expect(result[0]['id'], 1);
      expect(result[0]['title'], 'Test Movie');
      expect(result[1]['id'], 2);
      expect(result[1]['title'], 'Test Movie 2');
    });

    test('should return empty list when watchlist is empty', () async {
      // act
      final result = await databaseHelper.getWatchlistMovies();

      // assert
      expect(result, isEmpty);
      expect(result.length, 0);
    });

    test('should remove movie from watchlist successfully', () async {
      // arrange
      await databaseHelper.insertWatchlist(testMovieTable);

      // verify movie is inserted
      var movie = await databaseHelper.getMovieById(1);
      expect(movie, isNotNull);

      // act
      final result = await databaseHelper.removeWatchlist(testMovieTable);

      // assert
      expect(result, 1);

      // verify movie is removed
      movie = await databaseHelper.getMovieById(1);
      expect(movie, isNull);
    });

    test('should return 0 when removing non-existent movie', () async {
      // act
      final result = await databaseHelper.removeWatchlist(testMovieTable);

      // assert
      expect(result, 0);
    });

    test('should remove correct movie when multiple movies exist', () async {
      // arrange
      await databaseHelper.insertWatchlist(testMovieTable);
      await databaseHelper.insertWatchlist(testMovieTable2);

      // act
      await databaseHelper.removeWatchlist(testMovieTable);

      // assert
      final movies = await databaseHelper.getWatchlistMovies();
      expect(movies.length, 1);
      expect(movies.first['id'], 2);
      expect(movies.first['title'], 'Test Movie 2');

      // verify first movie is removed
      final removedMovie = await databaseHelper.getMovieById(1);
      expect(removedMovie, isNull);
    });

    test('should handle movie with null posterPath', () async {
      // arrange
      final movieWithNullPoster = MovieTable(
        id: 3,
        title: 'Movie Without Poster',
        posterPath: null,
        overview: 'Overview',
      );

      // act
      await databaseHelper.insertWatchlist(movieWithNullPoster);
      final result = await databaseHelper.getMovieById(3);

      // assert
      expect(result, isNotNull);
      expect(result!['id'], 3);
      expect(result['posterPath'], isNull);
      expect(result['title'], 'Movie Without Poster');
    });

    test('should maintain data integrity across operations', () async {
      // arrange & act
      await databaseHelper.insertWatchlist(testMovieTable);
      await databaseHelper.insertWatchlist(testMovieTable2);

      final movie1 = await databaseHelper.getMovieById(1);
      expect(movie1, isNotNull);

      await databaseHelper.removeWatchlist(testMovieTable);

      final movie2 = await databaseHelper.getMovieById(2);
      final removedMovie = await databaseHelper.getMovieById(1);

      // assert
      expect(movie2, isNotNull);
      expect(removedMovie, isNull);

      final remainingMovies = await databaseHelper.getWatchlistMovies();
      expect(remainingMovies.length, 1);
      expect(remainingMovies.first['id'], 2);
    });

    test('should handle database operations sequentially', () async {
      // Test multiple sequential operations
      for (int i = 1; i <= 5; i++) {
        final movie = MovieTable(
          id: i,
          title: 'Movie $i',
          posterPath: '/movie$i.jpg',
          overview: 'Overview $i',
        );
        await databaseHelper.insertWatchlist(movie);
      }

      final movies = await databaseHelper.getWatchlistMovies();
      expect(movies.length, 5);

      // Remove some movies
      await databaseHelper.removeWatchlist(MovieTable(
        id: 2,
        title: 'Movie 2',
        posterPath: '/movie2.jpg',
        overview: 'Overview 2',
      ));

      await databaseHelper.removeWatchlist(MovieTable(
        id: 4,
        title: 'Movie 4',
        posterPath: '/movie4.jpg',
        overview: 'Overview 4',
      ));

      final remainingMovies = await databaseHelper.getWatchlistMovies();
      expect(remainingMovies.length, 3);

      // Verify correct movies remain
      final ids = remainingMovies.map((m) => m['id']).toList();
      expect(ids, containsAll([1, 3, 5]));
      expect(ids, isNot(contains(2)));
      expect(ids, isNot(contains(4)));
    });

    test('should verify table structure has all required columns', () async {
      // act
      final db = await databaseHelper.database;
      final result = await db!.rawQuery("PRAGMA table_info(watchlist)");

      // assert
      expect(result.length, 4); // id, title, overview, posterPath

      final columnNames = result.map((col) => col['name']).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('title'));
      expect(columnNames, contains('overview'));
      expect(columnNames, contains('posterPath'));
    });

    test('should handle concurrent inserts', () async {
      // arrange
      final movies = List.generate(
        10,
        (i) => MovieTable(
          id: i + 1,
          title: 'Movie ${i + 1}',
          posterPath: '/movie${i + 1}.jpg',
          overview: 'Overview ${i + 1}',
        ),
      );

      // act - insert concurrently
      await Future.wait(
        movies.map((movie) => databaseHelper.insertWatchlist(movie)),
      );

      // assert
      final allMovies = await databaseHelper.getWatchlistMovies();
      expect(allMovies.length, 10);
    });
  });
}
