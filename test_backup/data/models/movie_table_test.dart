import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('MovieTable', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tMovieTable, isA<Object>());
    });

    test('should have correct props', () {
      // assert
      expect(
        tMovieTable.props,
        [1, 'title', 'posterPath', 'overview'],
      );
    });

    group('fromEntity', () {
      test('should return a valid MovieTable from MovieDetail entity', () {
        // act
        final result = MovieTable.fromEntity(tMovieDetail);

        // assert
        expect(result, isA<MovieTable>());
        expect(result.id, tMovieDetail.id);
        expect(result.title, tMovieDetail.title);
        expect(result.posterPath, tMovieDetail.posterPath);
        expect(result.overview, tMovieDetail.overview);
      });

      test('should create MovieTable with correct values from entity', () {
        // act
        final result = MovieTable.fromEntity(tMovieDetail);

        // assert
        expect(result.id, 1);
        expect(result.title, 'title');
        expect(result.posterPath, 'posterPath');
        expect(result.overview, 'overview');
      });
    });

    group('fromMap', () {
      test('should return a valid MovieTable from Map', () {
        // arrange
        final Map<String, dynamic> map = {
          'id': 1,
          'title': 'title',
          'posterPath': 'posterPath',
          'overview': 'overview',
        };

        // act
        final result = MovieTable.fromMap(map);

        // assert
        expect(result, isA<MovieTable>());
        expect(result.id, 1);
        expect(result.title, 'title');
        expect(result.posterPath, 'posterPath');
        expect(result.overview, 'overview');
      });

      test('should handle nullable fields from Map', () {
        // arrange
        final Map<String, dynamic> map = {
          'id': 1,
          'title': null,
          'posterPath': null,
          'overview': null,
        };

        // act
        final result = MovieTable.fromMap(map);

        // assert
        expect(result.id, 1);
        expect(result.title, null);
        expect(result.posterPath, null);
        expect(result.overview, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tMovieTable.toJson();

        // assert
        final expectedMap = {
          'id': 1,
          'title': 'title',
          'posterPath': 'posterPath',
          'overview': 'overview',
        };
        expect(result, expectedMap);
      });

      test('should convert to JSON and back correctly', () {
        // act
        final json = tMovieTable.toJson();
        final result = MovieTable.fromMap(json);

        // assert
        expect(result, tMovieTable);
      });

      test('should have all required keys in JSON', () {
        // act
        final result = tMovieTable.toJson();

        // assert
        expect(result.containsKey('id'), true);
        expect(result.containsKey('title'), true);
        expect(result.containsKey('posterPath'), true);
        expect(result.containsKey('overview'), true);
      });
    });

    group('toEntity', () {
      test('should return a Movie entity', () {
        // act
        final result = tMovieTable.toEntity();

        // assert
        expect(result, isA<Movie>());
      });

      test('should return Movie with correct values', () {
        // act
        final result = tMovieTable.toEntity();

        // assert
        expect(result.id, 1);
        expect(result.title, 'title');
        expect(result.posterPath, 'posterPath');
        expect(result.overview, 'overview');
      });

      test('should use Movie.watchlist constructor', () {
        // act
        final result = tMovieTable.toEntity();

        // assert
        expect(result.adult, null);
        expect(result.backdropPath, null);
        expect(result.genreIds, null);
        expect(result.originalTitle, null);
        expect(result.popularity, null);
        expect(result.releaseDate, null);
        expect(result.video, null);
        expect(result.voteAverage, null);
        expect(result.voteCount, null);
      });
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final tMovieTable1 = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );
        final tMovieTable2 = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );

        // assert
        expect(tMovieTable1, equals(tMovieTable2));
      });

      test('should not be equal when id is different', () {
        // arrange
        final tMovieTable1 = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );
        final tMovieTable2 = MovieTable(
          id: 2,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );

        // assert
        expect(tMovieTable1, isNot(equals(tMovieTable2)));
      });

      test('should not be equal when title is different', () {
        // arrange
        final tMovieTable1 = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );
        final tMovieTable2 = MovieTable(
          id: 1,
          title: 'different title',
          posterPath: 'posterPath',
          overview: 'overview',
        );

        // assert
        expect(tMovieTable1, isNot(equals(tMovieTable2)));
      });
    });
  });
}
