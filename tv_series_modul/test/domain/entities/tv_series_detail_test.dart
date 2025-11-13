import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/domain/entities/tv_series_detail.dart';

void main() {
  const tGenre = Genre(id: 1, name: 'Drama');
  const tSeason = Season(
    id: 1,
    name: 'Season 1',
    seasonNumber: 1,
    episodeCount: 10,
    posterPath: '/season1.jpg',
    airDate: '2008-01-20',
    overview: 'First season',
  );

  const tTvSeriesDetail = TvSeriesDetail(
    id: 1,
    name: 'Breaking Bad',
    overview: 'A high school chemistry teacher turned methamphetamine producer',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 9.5,
    voteCount: 10000,
    firstAirDate: '2008-01-20',
    lastAirDate: '2013-09-29',
    genres: [tGenre],
    numberOfSeasons: 5,
    numberOfEpisodes: 62,
    seasons: [tSeason],
    status: 'Ended',
    type: 'Scripted',
    inProduction: false,
    originCountry: ['US'],
  );

  group('Genre', () {
    test('should be a subclass of Equatable', () {
      expect(tGenre, isA<Object>());
    });

    test('should have correct props', () {
      expect(tGenre.props, [1, 'Drama']);
    });

    test('should be equal when all properties are the same', () {
      const genre1 = Genre(id: 1, name: 'Drama');
      const genre2 = Genre(id: 1, name: 'Drama');
      expect(genre1, equals(genre2));
    });
  });

  group('Season', () {
    test('should be a subclass of Equatable', () {
      expect(tSeason, isA<Object>());
    });

    test('should have correct props', () {
      expect(tSeason.props, [
        1,
        'Season 1',
        1,
        10,
        '/season1.jpg',
        '2008-01-20',
        'First season',
      ]);
    });

    test('should handle nullable fields', () {
      const seasonWithNulls = Season(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        episodeCount: 10,
        posterPath: null,
        airDate: null,
        overview: 'Overview',
      );

      expect(seasonWithNulls.posterPath, null);
      expect(seasonWithNulls.airDate, null);
    });

    test('should be equal when all properties are the same', () {
      const season1 = Season(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        episodeCount: 10,
        overview: 'Overview',
      );
      const season2 = Season(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        episodeCount: 10,
        overview: 'Overview',
      );
      expect(season1, equals(season2));
    });
  });

  group('TvSeriesDetail', () {
    test('should be a subclass of Equatable', () {
      expect(tTvSeriesDetail, isA<Object>());
    });

    test('should have correct props', () {
      expect(tTvSeriesDetail.props.length, 18);
    });

    test('should create instance with correct values', () {
      expect(tTvSeriesDetail.id, 1);
      expect(tTvSeriesDetail.name, 'Breaking Bad');
      expect(tTvSeriesDetail.posterPath, '/poster.jpg');
      expect(tTvSeriesDetail.numberOfSeasons, 5);
      expect(tTvSeriesDetail.numberOfEpisodes, 62);
      expect(tTvSeriesDetail.status, 'Ended');
      expect(tTvSeriesDetail.type, 'Scripted');
      expect(tTvSeriesDetail.inProduction, false);
    });

    test('should handle nullable fields', () {
      const tvSeriesWithNulls = TvSeriesDetail(
        id: 1,
        name: 'Breaking Bad',
        overview: 'Overview',
        posterPath: '/poster.jpg',
        backdropPath: null,
        voteAverage: 9.5,
        voteCount: 10000,
        firstAirDate: '2008-01-20',
        lastAirDate: null,
        genres: [],
        numberOfSeasons: 5,
        numberOfEpisodes: 62,
        seasons: [],
        status: 'Ended',
        type: 'Scripted',
        inProduction: false,
        originCountry: ['US'],
      );

      expect(tvSeriesWithNulls.backdropPath, null);
      expect(tvSeriesWithNulls.lastAirDate, null);
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        const tvDetail1 = TvSeriesDetail(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          genres: [],
          numberOfSeasons: 5,
          numberOfEpisodes: 62,
          seasons: [],
          status: 'Ended',
          type: 'Scripted',
          inProduction: false,
          originCountry: ['US'],
        );
        const tvDetail2 = TvSeriesDetail(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          genres: [],
          numberOfSeasons: 5,
          numberOfEpisodes: 62,
          seasons: [],
          status: 'Ended',
          type: 'Scripted',
          inProduction: false,
          originCountry: ['US'],
        );

        expect(tvDetail1, equals(tvDetail2));
      });

      test('should not be equal when id is different', () {
        const tvDetail1 = TvSeriesDetail(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          genres: [],
          numberOfSeasons: 5,
          numberOfEpisodes: 62,
          seasons: [],
          status: 'Ended',
          type: 'Scripted',
          inProduction: false,
          originCountry: ['US'],
        );
        const tvDetail2 = TvSeriesDetail(
          id: 2,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          genres: [],
          numberOfSeasons: 5,
          numberOfEpisodes: 62,
          seasons: [],
          status: 'Ended',
          type: 'Scripted',
          inProduction: false,
          originCountry: ['US'],
        );

        expect(tvDetail1, isNot(equals(tvDetail2)));
      });
    });
  });
}
