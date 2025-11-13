import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/data/models/tv_series_table.dart';
import 'package:tv_series_modul/domain/entities/tv_series.dart';
import 'package:tv_series_modul/domain/entities/tv_series_detail.dart';

void main() {
  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'Breaking Bad',
    overview: 'A high school chemistry teacher turned methamphetamine producer',
    posterPath: '/poster.jpg',
  );

  const tTvSeriesDetail = TvSeriesDetail(
    id: 1,
    name: 'Breaking Bad',
    overview: 'A high school chemistry teacher turned methamphetamine producer',
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

  group('TvSeriesTable', () {
    group('fromEntity', () {
      test('should return a valid TvSeriesTable from TvSeriesDetail entity', () {
        // act
        final result = TvSeriesTable.fromEntity(tTvSeriesDetail);

        // assert
        expect(result, isA<TvSeriesTable>());
        expect(result.id, tTvSeriesDetail.id);
        expect(result.name, tTvSeriesDetail.name);
        expect(result.overview, tTvSeriesDetail.overview);
        expect(result.posterPath, tTvSeriesDetail.posterPath);
      });
    });

    group('fromMap', () {
      test('should return a valid TvSeriesTable from Map', () {
        // arrange
        final Map<String, dynamic> map = {
          'id': 1,
          'name': 'Breaking Bad',
          'overview':
              'A high school chemistry teacher turned methamphetamine producer',
          'posterPath': '/poster.jpg',
        };

        // act
        final result = TvSeriesTable.fromMap(map);

        // assert
        expect(result, isA<TvSeriesTable>());
        expect(result.id, 1);
        expect(result.name, 'Breaking Bad');
        expect(result.overview,
            'A high school chemistry teacher turned methamphetamine producer');
        expect(result.posterPath, '/poster.jpg');
      });
    });

    group('toMap', () {
      test('should return a Map containing proper data', () {
        // act
        final result = tTvSeriesTable.toMap();

        // assert
        final expectedMap = {
          'id': 1,
          'name': 'Breaking Bad',
          'overview':
              'A high school chemistry teacher turned methamphetamine producer',
          'posterPath': '/poster.jpg',
        };
        expect(result, expectedMap);
      });

      test('should convert to Map and back correctly', () {
        // act
        final map = tTvSeriesTable.toMap();
        final result = TvSeriesTable.fromMap(map);

        // assert
        expect(result.id, tTvSeriesTable.id);
        expect(result.name, tTvSeriesTable.name);
        expect(result.overview, tTvSeriesTable.overview);
        expect(result.posterPath, tTvSeriesTable.posterPath);
      });
    });

    group('toEntity', () {
      test('should return a TvSeries entity', () {
        // act
        final result = tTvSeriesTable.toEntity();

        // assert
        expect(result, isA<TvSeries>());
        expect(result.id, 1);
        expect(result.name, 'Breaking Bad');
        expect(result.overview,
            'A high school chemistry teacher turned methamphetamine producer');
        expect(result.posterPath, '/poster.jpg');
      });

      test('should set default values for non-table fields', () {
        // act
        final result = tTvSeriesTable.toEntity();

        // assert
        expect(result.voteAverage, 0.0);
        expect(result.voteCount, 0);
        expect(result.firstAirDate, '');
        expect(result.originCountry, []);
        expect(result.genreIds, []);
      });
    });
  });
}
