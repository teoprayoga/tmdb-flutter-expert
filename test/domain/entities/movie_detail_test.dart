import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: '/posterPath',
    releaseDate: '2021-01-01',
    runtime: 120,
    title: 'title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('MovieDetail', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tMovieDetail, isA<Object>());
    });

    test('should have correct props', () {
      // assert
      expect(tMovieDetail.props, [
        false,
        '/backdropPath',
        [Genre(id: 1, name: 'Action')],
        1,
        'originalTitle',
        'overview',
        '/posterPath',
        '2021-01-01',
        'title',
        1.0,
        1,
      ]);
    });

    test('should create instance with all required parameters', () {
      // assert
      expect(tMovieDetail.adult, false);
      expect(tMovieDetail.backdropPath, '/backdropPath');
      expect(tMovieDetail.genres, [Genre(id: 1, name: 'Action')]);
      expect(tMovieDetail.id, 1);
      expect(tMovieDetail.originalTitle, 'originalTitle');
      expect(tMovieDetail.overview, 'overview');
      expect(tMovieDetail.posterPath, '/posterPath');
      expect(tMovieDetail.releaseDate, '2021-01-01');
      expect(tMovieDetail.runtime, 120);
      expect(tMovieDetail.title, 'title');
      expect(tMovieDetail.voteAverage, 1.0);
      expect(tMovieDetail.voteCount, 1);
    });

    test('should have default values for optional parameters', () {
      // assert
      expect(tMovieDetail.seasons, null);
      expect(tMovieDetail.numberOfSeasons, 0);
      expect(tMovieDetail.numberOfEpisodes, 0);
      expect(tMovieDetail.type, '');
      expect(tMovieDetail.inProduction, false);
      expect(tMovieDetail.firstAirDate, null);
      expect(tMovieDetail.lastAirDate, null);
      expect(tMovieDetail.status, null);
    });

    test('should create instance with optional parameters', () {
      // arrange
      const tSeason = Season(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        episodeCount: 10,
        posterPath: '/poster.jpg',
        airDate: '2021-01-01',
        overview: 'Season 1 overview',
      );

      final movieDetailWithOptionals = MovieDetail(
        adult: false,
        backdropPath: '/backdropPath',
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        originalTitle: 'originalTitle',
        overview: 'overview',
        posterPath: '/posterPath',
        releaseDate: '2021-01-01',
        runtime: 120,
        title: 'title',
        voteAverage: 1.0,
        voteCount: 1,
        status: 'Released',
        seasons: [tSeason],
        numberOfSeasons: 1,
        numberOfEpisodes: 10,
        type: 'Scripted',
        inProduction: true,
        firstAirDate: '2021-01-01',
        lastAirDate: '2021-12-31',
      );

      // assert
      expect(movieDetailWithOptionals.status, 'Released');
      expect(movieDetailWithOptionals.seasons, [tSeason]);
      expect(movieDetailWithOptionals.numberOfSeasons, 1);
      expect(movieDetailWithOptionals.numberOfEpisodes, 10);
      expect(movieDetailWithOptionals.type, 'Scripted');
      expect(movieDetailWithOptionals.inProduction, true);
      expect(movieDetailWithOptionals.firstAirDate, '2021-01-01');
      expect(movieDetailWithOptionals.lastAirDate, '2021-12-31');
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final movieDetail1 = MovieDetail(
          adult: false,
          backdropPath: '/backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          runtime: 120,
          title: 'title',
          voteAverage: 1.0,
          voteCount: 1,
        );
        final movieDetail2 = MovieDetail(
          adult: false,
          backdropPath: '/backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          runtime: 120,
          title: 'title',
          voteAverage: 1.0,
          voteCount: 1,
        );

        // assert
        expect(movieDetail1, equals(movieDetail2));
      });

      test('should not be equal when id is different', () {
        // arrange
        final movieDetail1 = MovieDetail(
          adult: false,
          backdropPath: '/backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          runtime: 120,
          title: 'title',
          voteAverage: 1.0,
          voteCount: 1,
        );
        final movieDetail2 = MovieDetail(
          adult: false,
          backdropPath: '/backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 2,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          runtime: 120,
          title: 'title',
          voteAverage: 1.0,
          voteCount: 1,
        );

        // assert
        expect(movieDetail1, isNot(equals(movieDetail2)));
      });

      test('should not be equal when title is different', () {
        // arrange
        final movieDetail1 = MovieDetail(
          adult: false,
          backdropPath: '/backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          runtime: 120,
          title: 'title',
          voteAverage: 1.0,
          voteCount: 1,
        );
        final movieDetail2 = MovieDetail(
          adult: false,
          backdropPath: '/backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          runtime: 120,
          title: 'different title',
          voteAverage: 1.0,
          voteCount: 1,
        );

        // assert
        expect(movieDetail1, isNot(equals(movieDetail2)));
      });
    });
  });
}
