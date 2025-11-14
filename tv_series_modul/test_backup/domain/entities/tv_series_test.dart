import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/domain/entities/tv_series.dart';

void main() {
  const tTvSeries = TvSeries(
    id: 1,
    name: 'Breaking Bad',
    overview: 'A high school chemistry teacher turned methamphetamine producer',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 9.5,
    voteCount: 10000,
    firstAirDate: '2008-01-20',
    originCountry: ['US'],
    genreIds: [18, 80],
  );

  group('TvSeries', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tTvSeries, isA<Object>());
    });

    test('should have correct props', () {
      // assert
      expect(tTvSeries.props, [
        1,
        'Breaking Bad',
        'A high school chemistry teacher turned methamphetamine producer',
        '/poster.jpg',
        '/backdrop.jpg',
        9.5,
        10000,
        '2008-01-20',
        ['US'],
        [18, 80],
      ]);
    });

    test('should create instance with correct values', () {
      // assert
      expect(tTvSeries.id, 1);
      expect(tTvSeries.name, 'Breaking Bad');
      expect(tTvSeries.overview,
          'A high school chemistry teacher turned methamphetamine producer');
      expect(tTvSeries.posterPath, '/poster.jpg');
      expect(tTvSeries.backdropPath, '/backdrop.jpg');
      expect(tTvSeries.voteAverage, 9.5);
      expect(tTvSeries.voteCount, 10000);
      expect(tTvSeries.firstAirDate, '2008-01-20');
      expect(tTvSeries.originCountry, ['US']);
      expect(tTvSeries.genreIds, [18, 80]);
    });

    test('should handle nullable backdropPath', () {
      // arrange
      const tvSeriesWithoutBackdrop = TvSeries(
        id: 1,
        name: 'Breaking Bad',
        overview: 'Overview',
        posterPath: '/poster.jpg',
        backdropPath: null,
        voteAverage: 9.5,
        voteCount: 10000,
        firstAirDate: '2008-01-20',
        originCountry: ['US'],
        genreIds: [18, 80],
      );

      // assert
      expect(tvSeriesWithoutBackdrop.backdropPath, null);
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        // arrange
        const tvSeries1 = TvSeries(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          backdropPath: '/backdrop.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          originCountry: ['US'],
          genreIds: [18, 80],
        );
        const tvSeries2 = TvSeries(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          backdropPath: '/backdrop.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          originCountry: ['US'],
          genreIds: [18, 80],
        );

        // assert
        expect(tvSeries1, equals(tvSeries2));
      });

      test('should not be equal when id is different', () {
        // arrange
        const tvSeries1 = TvSeries(
          id: 1,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          originCountry: ['US'],
          genreIds: [18, 80],
        );
        const tvSeries2 = TvSeries(
          id: 2,
          name: 'Breaking Bad',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          voteAverage: 9.5,
          voteCount: 10000,
          firstAirDate: '2008-01-20',
          originCountry: ['US'],
          genreIds: [18, 80],
        );

        // assert
        expect(tvSeries1, isNot(equals(tvSeries2)));
      });
    });
  });
}
