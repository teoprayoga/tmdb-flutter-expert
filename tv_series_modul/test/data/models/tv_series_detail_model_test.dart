import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/data/models/tv_series_detail_model.dart';
import 'package:tv_series_modul/domain/entities/tv_series_detail.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Drama');
  final tSeasonModel = SeasonModel(
    id: 1,
    name: 'Season 1',
    seasonNumber: 1,
    episodeCount: 10,
    posterPath: '/season1.jpg',
    airDate: '2008-01-20',
    overview: 'First season',
  );

  final tTvSeriesDetailModel = TvSeriesDetailModel(
    id: 1,
    name: 'Breaking Bad',
    overview: 'A high school chemistry teacher',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 9.5,
    voteCount: 10000,
    firstAirDate: '2008-01-20',
    lastAirDate: '2013-09-29',
    genres: [tGenreModel],
    numberOfSeasons: 5,
    numberOfEpisodes: 62,
    seasons: [tSeasonModel],
    status: 'Ended',
    type: 'Scripted',
    inProduction: false,
    originCountry: ['US'],
  );

  group('GenreModel', () {
    test('should convert from JSON correctly', () {
      final json = {'id': 1, 'name': 'Drama'};
      final result = GenreModel.fromJson(json);

      expect(result.id, 1);
      expect(result.name, 'Drama');
    });

    test('should convert to JSON correctly', () {
      final result = tGenreModel.toJson();

      expect(result, {'id': 1, 'name': 'Drama'});
    });

    test('should convert to entity correctly', () {
      final result = tGenreModel.toEntity();

      expect(result, isA<Genre>());
      expect(result.id, 1);
      expect(result.name, 'Drama');
    });
  });

  group('SeasonModel', () {
    test('should convert from JSON correctly', () {
      final json = {
        'id': 1,
        'name': 'Season 1',
        'season_number': 1,
        'episode_count': 10,
        'poster_path': '/season1.jpg',
        'air_date': '2008-01-20',
        'overview': 'First season',
      };
      final result = SeasonModel.fromJson(json);

      expect(result.id, 1);
      expect(result.name, 'Season 1');
      expect(result.seasonNumber, 1);
      expect(result.episodeCount, 10);
    });

    test('should handle null overview with empty string', () {
      final json = {
        'id': 1,
        'name': 'Season 1',
        'season_number': 1,
        'episode_count': 10,
        'overview': null,
      };
      final result = SeasonModel.fromJson(json);

      expect(result.overview, '');
    });

    test('should convert to JSON correctly', () {
      final result = tSeasonModel.toJson();

      expect(result['season_number'], 1);
      expect(result['episode_count'], 10);
    });

    test('should convert to entity correctly', () {
      final result = tSeasonModel.toEntity();

      expect(result, isA<Season>());
      expect(result.seasonNumber, 1);
      expect(result.episodeCount, 10);
    });
  });

  group('TvSeriesDetailModel', () {
    test('should be a subclass of TvSeriesDetail entity when converted', () {
      final result = tTvSeriesDetailModel.toEntity();
      expect(result, isA<TvSeriesDetail>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'name': 'Breaking Bad',
          'overview': 'A high school chemistry teacher',
          'poster_path': '/poster.jpg',
          'backdrop_path': '/backdrop.jpg',
          'vote_average': 9.5,
          'vote_count': 10000,
          'first_air_date': '2008-01-20',
          'last_air_date': '2013-09-29',
          'genres': [
            {'id': 1, 'name': 'Drama'}
          ],
          'number_of_seasons': 5,
          'number_of_episodes': 62,
          'seasons': [
            {
              'id': 1,
              'name': 'Season 1',
              'season_number': 1,
              'episode_count': 10,
              'poster_path': '/season1.jpg',
              'air_date': '2008-01-20',
              'overview': 'First season',
            }
          ],
          'status': 'Ended',
          'type': 'Scripted',
          'in_production': false,
          'origin_country': ['US'],
        };

        final result = TvSeriesDetailModel.fromJson(jsonMap);

        expect(result.id, 1);
        expect(result.name, 'Breaking Bad');
        expect(result.numberOfSeasons, 5);
        expect(result.numberOfEpisodes, 62);
      });

      test('should handle null and missing fields with defaults', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'name': 'Breaking Bad',
        };

        final result = TvSeriesDetailModel.fromJson(jsonMap);

        expect(result.overview, '');
        expect(result.voteAverage, 0.0);
        expect(result.voteCount, 0);
        expect(result.genres, []);
        expect(result.seasons, []);
        expect(result.status, '');
        expect(result.type, '');
        expect(result.inProduction, false);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tTvSeriesDetailModel.toJson();

        expect(result['id'], 1);
        expect(result['name'], 'Breaking Bad');
        expect(result['number_of_seasons'], 5);
        expect(result['number_of_episodes'], 62);
        expect(result['status'], 'Ended');
      });

      test('should convert to JSON and back correctly', () {
        final json = tTvSeriesDetailModel.toJson();
        final result = TvSeriesDetailModel.fromJson(json);

        expect(result.id, tTvSeriesDetailModel.id);
        expect(result.name, tTvSeriesDetailModel.name);
      });
    });

    group('toEntity', () {
      test('should return a TvSeriesDetail entity with proper data', () {
        final result = tTvSeriesDetailModel.toEntity();

        expect(result, isA<TvSeriesDetail>());
        expect(result.id, 1);
        expect(result.name, 'Breaking Bad');
        expect(result.numberOfSeasons, 5);
        expect(result.numberOfEpisodes, 62);
      });

      test('should handle null posterPath with empty string', () {
        final modelWithNullPoster = TvSeriesDetailModel(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: null,
          voteAverage: 9.5,
          voteCount: 10000,
          genres: [],
          numberOfSeasons: 5,
          numberOfEpisodes: 62,
          seasons: [],
          status: 'Ended',
          type: 'Scripted',
          inProduction: false,
          originCountry: ['US'],
        );

        final result = modelWithNullPoster.toEntity();

        expect(result.posterPath, '');
      });

      test('should handle null firstAirDate with empty string', () {
        final modelWithNullDate = TvSeriesDetailModel(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: null,
          genres: [],
          numberOfSeasons: 5,
          numberOfEpisodes: 62,
          seasons: [],
          status: 'Ended',
          type: 'Scripted',
          inProduction: false,
          originCountry: ['US'],
        );

        final result = modelWithNullDate.toEntity();

        expect(result.firstAirDate, '');
      });
    });
  });
}
