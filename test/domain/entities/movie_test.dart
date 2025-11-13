import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovie = Movie(
    adult: false,
    backdropPath: '/backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1.0,
    posterPath: '/posterPath',
    releaseDate: '2021-01-01',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('Movie', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tMovie, isA<Object>());
    });

    test('should have correct props', () {
      // assert
      expect(tMovie.props, [
        false,
        '/backdropPath',
        [1, 2, 3],
        1,
        'originalTitle',
        'overview',
        1.0,
        '/posterPath',
        '2021-01-01',
        'title',
        false,
        1.0,
        1,
      ]);
    });

    test('should create instance with all parameters', () {
      // assert
      expect(tMovie.adult, false);
      expect(tMovie.backdropPath, '/backdropPath');
      expect(tMovie.genreIds, [1, 2, 3]);
      expect(tMovie.id, 1);
      expect(tMovie.originalTitle, 'originalTitle');
      expect(tMovie.overview, 'overview');
      expect(tMovie.popularity, 1.0);
      expect(tMovie.posterPath, '/posterPath');
      expect(tMovie.releaseDate, '2021-01-01');
      expect(tMovie.title, 'title');
      expect(tMovie.video, false);
      expect(tMovie.voteAverage, 1.0);
      expect(tMovie.voteCount, 1);
    });

    group('watchlist constructor', () {
      test('should create Movie with minimal parameters', () {
        // act
        final watchlistMovie = Movie.watchlist(
          id: 1,
          overview: 'overview',
          posterPath: '/posterPath',
          title: 'title',
        );

        // assert
        expect(watchlistMovie.id, 1);
        expect(watchlistMovie.overview, 'overview');
        expect(watchlistMovie.posterPath, '/posterPath');
        expect(watchlistMovie.title, 'title');
      });

      test('should have nullable fields when using watchlist constructor', () {
        // act
        final watchlistMovie = Movie.watchlist(
          id: 1,
          overview: 'overview',
          posterPath: '/posterPath',
          title: 'title',
        );

        // assert
        expect(watchlistMovie.adult, null);
        expect(watchlistMovie.backdropPath, null);
        expect(watchlistMovie.genreIds, null);
        expect(watchlistMovie.originalTitle, null);
        expect(watchlistMovie.popularity, null);
        expect(watchlistMovie.releaseDate, null);
        expect(watchlistMovie.video, null);
        expect(watchlistMovie.voteAverage, null);
        expect(watchlistMovie.voteCount, null);
      });
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final movie1 = Movie(
          adult: false,
          backdropPath: '/backdropPath',
          genreIds: [1, 2, 3],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          popularity: 1.0,
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          title: 'title',
          video: false,
          voteAverage: 1.0,
          voteCount: 1,
        );
        final movie2 = Movie(
          adult: false,
          backdropPath: '/backdropPath',
          genreIds: [1, 2, 3],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          popularity: 1.0,
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          title: 'title',
          video: false,
          voteAverage: 1.0,
          voteCount: 1,
        );

        // assert
        expect(movie1, equals(movie2));
      });

      test('should not be equal when id is different', () {
        // arrange
        final movie1 = Movie(
          adult: false,
          backdropPath: '/backdropPath',
          genreIds: [1, 2, 3],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          popularity: 1.0,
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          title: 'title',
          video: false,
          voteAverage: 1.0,
          voteCount: 1,
        );
        final movie2 = Movie(
          adult: false,
          backdropPath: '/backdropPath',
          genreIds: [1, 2, 3],
          id: 2,
          originalTitle: 'originalTitle',
          overview: 'overview',
          popularity: 1.0,
          posterPath: '/posterPath',
          releaseDate: '2021-01-01',
          title: 'title',
          video: false,
          voteAverage: 1.0,
          voteCount: 1,
        );

        // assert
        expect(movie1, isNot(equals(movie2)));
      });
    });
  });
}
