import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeason = Season(
    id: 1,
    name: 'Season 1',
    seasonNumber: 1,
    episodeCount: 10,
    posterPath: '/poster.jpg',
    airDate: '2021-01-01',
    overview: 'Season 1 overview',
  );

  group('Season', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tSeason, isA<Object>());
    });

    test('should have correct props', () {
      // assert
      expect(tSeason.props, [
        1,
        'Season 1',
        1,
        10,
        '/poster.jpg',
        '2021-01-01',
        'Season 1 overview',
      ]);
    });

    test('should create instance with correct values', () {
      // assert
      expect(tSeason.id, 1);
      expect(tSeason.name, 'Season 1');
      expect(tSeason.seasonNumber, 1);
      expect(tSeason.episodeCount, 10);
      expect(tSeason.posterPath, '/poster.jpg');
      expect(tSeason.airDate, '2021-01-01');
      expect(tSeason.overview, 'Season 1 overview');
    });

    test('should handle nullable fields', () {
      // arrange
      const seasonWithNulls = Season(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        episodeCount: 10,
        posterPath: null,
        airDate: null,
        overview: 'Overview',
      );

      // assert
      expect(seasonWithNulls.posterPath, null);
      expect(seasonWithNulls.airDate, null);
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        // arrange
        const season1 = Season(
          id: 1,
          name: 'Season 1',
          seasonNumber: 1,
          episodeCount: 10,
          posterPath: '/poster.jpg',
          airDate: '2021-01-01',
          overview: 'Season 1 overview',
        );
        const season2 = Season(
          id: 1,
          name: 'Season 1',
          seasonNumber: 1,
          episodeCount: 10,
          posterPath: '/poster.jpg',
          airDate: '2021-01-01',
          overview: 'Season 1 overview',
        );

        // assert
        expect(season1, equals(season2));
      });

      test('should not be equal when id is different', () {
        // arrange
        const season1 = Season(
          id: 1,
          name: 'Season 1',
          seasonNumber: 1,
          episodeCount: 10,
          posterPath: '/poster.jpg',
          airDate: '2021-01-01',
          overview: 'Season 1 overview',
        );
        const season2 = Season(
          id: 2,
          name: 'Season 1',
          seasonNumber: 1,
          episodeCount: 10,
          posterPath: '/poster.jpg',
          airDate: '2021-01-01',
          overview: 'Season 1 overview',
        );

        // assert
        expect(season1, isNot(equals(season2)));
      });

      test('should not be equal when seasonNumber is different', () {
        // arrange
        const season1 = Season(
          id: 1,
          name: 'Season 1',
          seasonNumber: 1,
          episodeCount: 10,
          posterPath: '/poster.jpg',
          airDate: '2021-01-01',
          overview: 'Season 1 overview',
        );
        const season2 = Season(
          id: 1,
          name: 'Season 1',
          seasonNumber: 2,
          episodeCount: 10,
          posterPath: '/poster.jpg',
          airDate: '2021-01-01',
          overview: 'Season 1 overview',
        );

        // assert
        expect(season1, isNot(equals(season2)));
      });
    });
  });
}
