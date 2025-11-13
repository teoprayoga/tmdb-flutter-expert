import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = SeasonModel(
    id: 1,
    name: 'Season 1',
    seasonNumber: 1,
    episodeCount: 10,
    posterPath: '/poster.jpg',
    airDate: '2021-01-01',
    overview: 'Season 1 overview',
  );

  group('SeasonModel', () {
    test('should be a valid model', () {
      // assert
      expect(tSeasonModel, isA<SeasonModel>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'name': 'Season 1',
          'season_number': 1,
          'episode_count': 10,
          'poster_path': '/poster.jpg',
          'air_date': '2021-01-01',
          'overview': 'Season 1 overview',
        };

        // act
        final result = SeasonModel.fromJson(jsonMap);

        // assert
        expect(result.id, 1);
        expect(result.name, 'Season 1');
        expect(result.seasonNumber, 1);
        expect(result.episodeCount, 10);
        expect(result.posterPath, '/poster.jpg');
        expect(result.airDate, '2021-01-01');
        expect(result.overview, 'Season 1 overview');
      });

      test('should handle null posterPath', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'name': 'Season 1',
          'season_number': 1,
          'episode_count': 10,
          'poster_path': null,
          'air_date': '2021-01-01',
          'overview': 'Season 1 overview',
        };

        // act
        final result = SeasonModel.fromJson(jsonMap);

        // assert
        expect(result.posterPath, null);
      });

      test('should handle null airDate', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'name': 'Season 1',
          'season_number': 1,
          'episode_count': 10,
          'poster_path': '/poster.jpg',
          'air_date': null,
          'overview': 'Season 1 overview',
        };

        // act
        final result = SeasonModel.fromJson(jsonMap);

        // assert
        expect(result.airDate, null);
      });

      test('should handle null overview with empty string', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'name': 'Season 1',
          'season_number': 1,
          'episode_count': 10,
          'poster_path': '/poster.jpg',
          'air_date': '2021-01-01',
          'overview': null,
        };

        // act
        final result = SeasonModel.fromJson(jsonMap);

        // assert
        expect(result.overview, '');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tSeasonModel.toJson();

        // assert
        final expectedJsonMap = {
          'id': 1,
          'name': 'Season 1',
          'season_number': 1,
          'episode_count': 10,
          'poster_path': '/poster.jpg',
          'air_date': '2021-01-01',
          'overview': 'Season 1 overview',
        };
        expect(result, expectedJsonMap);
      });

      test('should convert to JSON and back correctly', () {
        // act
        final json = tSeasonModel.toJson();
        final result = SeasonModel.fromJson(json);

        // assert
        expect(result.id, tSeasonModel.id);
        expect(result.name, tSeasonModel.name);
        expect(result.seasonNumber, tSeasonModel.seasonNumber);
        expect(result.episodeCount, tSeasonModel.episodeCount);
        expect(result.posterPath, tSeasonModel.posterPath);
        expect(result.airDate, tSeasonModel.airDate);
        expect(result.overview, tSeasonModel.overview);
      });

      test('should have all required keys in JSON', () {
        // act
        final result = tSeasonModel.toJson();

        // assert
        expect(result.containsKey('id'), true);
        expect(result.containsKey('name'), true);
        expect(result.containsKey('season_number'), true);
        expect(result.containsKey('episode_count'), true);
        expect(result.containsKey('poster_path'), true);
        expect(result.containsKey('air_date'), true);
        expect(result.containsKey('overview'), true);
      });
    });

    group('toEntity', () {
      test('should return a Season entity', () {
        // act
        final result = tSeasonModel.toEntity();

        // assert
        expect(result, isA<Season>());
      });

      test('should return Season with correct values', () {
        // act
        final result = tSeasonModel.toEntity();

        // assert
        expect(result.id, 1);
        expect(result.name, 'Season 1');
        expect(result.seasonNumber, 1);
        expect(result.episodeCount, 10);
        expect(result.posterPath, '/poster.jpg');
        expect(result.airDate, '2021-01-01');
        expect(result.overview, 'Season 1 overview');
      });

      test('should handle nullable fields in toEntity', () {
        // arrange
        final seasonWithNulls = SeasonModel(
          id: 1,
          name: 'Season 1',
          seasonNumber: 1,
          episodeCount: 10,
          posterPath: null,
          airDate: null,
          overview: 'Overview',
        );

        // act
        final result = seasonWithNulls.toEntity();

        // assert
        expect(result.posterPath, null);
        expect(result.airDate, null);
      });
    });
  });
}
