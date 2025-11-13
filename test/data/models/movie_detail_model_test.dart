import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: "Action");

  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: "/path.jpg",
    budget: 100000000,
    genres: [tGenreModel],
    homepage: "https://example.com",
    id: 1,
    imdbId: "tt1234567",
    originalLanguage: "en",
    originalTitle: "Original Title",
    overview: "Overview",
    popularity: 123.456,
    posterPath: "/poster.jpg",
    releaseDate: "2021-01-01",
    revenue: 200000000,
    runtime: 120,
    status: "Released",
    tagline: "Tagline",
    title: "Title",
    video: false,
    voteAverage: 7.8,
    voteCount: 1000,
  );

  group('MovieDetailResponse', () {
    test('should be a subclass of MovieDetail entity', () {
      // assert
      expect(tMovieDetailResponse.toEntity(), isA<MovieDetail>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          "adult": false,
          "backdrop_path": "/path.jpg",
          "budget": 100000000,
          "genres": [
            {"id": 1, "name": "Action"}
          ],
          "homepage": "https://example.com",
          "id": 1,
          "imdb_id": "tt1234567",
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 123.456,
          "poster_path": "/poster.jpg",
          "release_date": "2021-01-01",
          "revenue": 200000000,
          "runtime": 120,
          "status": "Released",
          "tagline": "Tagline",
          "title": "Title",
          "video": false,
          "vote_average": 7.8,
          "vote_count": 1000,
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result, equals(tMovieDetailResponse));
      });

      test('should handle nullable fields correctly', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          "adult": false,
          "backdrop_path": null,
          "budget": 0,
          "genres": [],
          "homepage": "",
          "id": 1,
          "imdb_id": null,
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 0.0,
          "poster_path": "/poster.jpg",
          "release_date": "2021-01-01",
          "revenue": 0,
          "runtime": 0,
          "status": "Released",
          "tagline": "",
          "title": "Title",
          "video": false,
          "vote_average": 0.0,
          "vote_count": 0,
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result.backdropPath, null);
        expect(result.imdbId, null);
        expect(result.genres, []);
      });

      test('should parse multiple genres correctly', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          "adult": false,
          "backdrop_path": "/path.jpg",
          "budget": 100000000,
          "genres": [
            {"id": 1, "name": "Action"},
            {"id": 2, "name": "Drama"},
            {"id": 3, "name": "Thriller"}
          ],
          "homepage": "https://example.com",
          "id": 1,
          "imdb_id": "tt1234567",
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 123.456,
          "poster_path": "/poster.jpg",
          "release_date": "2021-01-01",
          "revenue": 200000000,
          "runtime": 120,
          "status": "Released",
          "tagline": "Tagline",
          "title": "Title",
          "video": false,
          "vote_average": 7.8,
          "vote_count": 1000,
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result.genres.length, 3);
        expect(result.genres[0].id, 1);
        expect(result.genres[0].name, "Action");
        expect(result.genres[1].id, 2);
        expect(result.genres[1].name, "Drama");
        expect(result.genres[2].id, 3);
        expect(result.genres[2].name, "Thriller");
      });

      test('should convert popularity to double correctly', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          "adult": false,
          "backdrop_path": "/path.jpg",
          "budget": 100000000,
          "genres": [],
          "homepage": "https://example.com",
          "id": 1,
          "imdb_id": "tt1234567",
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 123,
          "poster_path": "/poster.jpg",
          "release_date": "2021-01-01",
          "revenue": 200000000,
          "runtime": 120,
          "status": "Released",
          "tagline": "Tagline",
          "title": "Title",
          "video": false,
          "vote_average": 8,
          "vote_count": 1000,
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result.popularity, isA<double>());
        expect(result.popularity, 123.0);
        expect(result.voteAverage, isA<double>());
        expect(result.voteAverage, 8.0);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tMovieDetailResponse.toJson();

        // assert
        final expectedJsonMap = {
          "adult": false,
          "backdrop_path": "/path.jpg",
          "budget": 100000000,
          "genres": [
            {"id": 1, "name": "Action"}
          ],
          "homepage": "https://example.com",
          "id": 1,
          "imdb_id": "tt1234567",
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 123.456,
          "poster_path": "/poster.jpg",
          "release_date": "2021-01-01",
          "revenue": 200000000,
          "runtime": 120,
          "status": "Released",
          "tagline": "Tagline",
          "title": "Title",
          "video": false,
          "vote_average": 7.8,
          "vote_count": 1000,
        };
        expect(result, equals(expectedJsonMap));
      });

      test('should handle nullable fields in toJson', () {
        // arrange
        final movieWithNulls = MovieDetailResponse(
          adult: false,
          backdropPath: null,
          budget: 0,
          genres: [],
          homepage: "",
          id: 1,
          imdbId: null,
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 0.0,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 0,
          runtime: 0,
          status: "Released",
          tagline: "",
          title: "Title",
          video: false,
          voteAverage: 0.0,
          voteCount: 0,
        );

        // act
        final result = movieWithNulls.toJson();

        // assert
        expect(result["backdrop_path"], null);
        expect(result["imdb_id"], null);
        expect(result["genres"], []);
      });

      test('should convert to JSON and back to model correctly', () {
        // act
        final json = tMovieDetailResponse.toJson();
        final result = MovieDetailResponse.fromJson(json);

        // assert
        expect(result, equals(tMovieDetailResponse));
      });

      test('should have all required keys in JSON output', () {
        // act
        final result = tMovieDetailResponse.toJson();

        // assert
        expect(result.containsKey("adult"), true);
        expect(result.containsKey("backdrop_path"), true);
        expect(result.containsKey("budget"), true);
        expect(result.containsKey("genres"), true);
        expect(result.containsKey("homepage"), true);
        expect(result.containsKey("id"), true);
        expect(result.containsKey("imdb_id"), true);
        expect(result.containsKey("original_language"), true);
        expect(result.containsKey("original_title"), true);
        expect(result.containsKey("overview"), true);
        expect(result.containsKey("popularity"), true);
        expect(result.containsKey("poster_path"), true);
        expect(result.containsKey("release_date"), true);
        expect(result.containsKey("revenue"), true);
        expect(result.containsKey("runtime"), true);
        expect(result.containsKey("status"), true);
        expect(result.containsKey("tagline"), true);
        expect(result.containsKey("title"), true);
        expect(result.containsKey("video"), true);
        expect(result.containsKey("vote_average"), true);
        expect(result.containsKey("vote_count"), true);
      });
    });

    group('toEntity', () {
      test('should return a MovieDetail entity with proper data', () {
        // act
        final result = tMovieDetailResponse.toEntity();

        // assert
        expect(result, isA<MovieDetail>());
        expect(result.adult, false);
        expect(result.backdropPath, "/path.jpg");
        expect(result.id, 1);
        expect(result.originalTitle, "Original Title");
        expect(result.overview, "Overview");
        expect(result.posterPath, "/poster.jpg");
        expect(result.releaseDate, "2021-01-01");
        expect(result.runtime, 120);
        expect(result.title, "Title");
        expect(result.voteAverage, 7.8);
        expect(result.voteCount, 1000);
      });

      test('should map genres to entities correctly', () {
        // act
        final result = tMovieDetailResponse.toEntity();

        // assert
        expect(result.genres.length, 1);
        expect(result.genres[0].id, 1);
        expect(result.genres[0].name, "Action");
      });

      test('should handle multiple genres in toEntity', () {
        // arrange
        final movieWithMultipleGenres = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [
            GenreModel(id: 1, name: "Action"),
            GenreModel(id: 2, name: "Drama"),
          ],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        // act
        final result = movieWithMultipleGenres.toEntity();

        // assert
        expect(result.genres.length, 2);
        expect(result.genres[0].id, 1);
        expect(result.genres[1].id, 2);
      });

      test('should handle nullable fields in toEntity', () {
        // arrange
        final movieWithNulls = MovieDetailResponse(
          adult: false,
          backdropPath: null,
          budget: 0,
          genres: [],
          homepage: "",
          id: 1,
          imdbId: null,
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 0.0,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 0,
          runtime: 0,
          status: "Released",
          tagline: "",
          title: "Title",
          video: false,
          voteAverage: 0.0,
          voteCount: 0,
        );

        // act
        final result = movieWithNulls.toEntity();

        // assert
        expect(result.backdropPath, null);
        expect(result.genres, []);
      });
    });

    group('Equatable props', () {
      test('should have correct props for equality comparison', () {
        // assert
        expect(tMovieDetailResponse.props.length, 21);
        expect(tMovieDetailResponse.props, [
          false,
          "/path.jpg",
          100000000,
          [tGenreModel],
          "https://example.com",
          1,
          "tt1234567",
          "en",
          "Original Title",
          "Overview",
          123.456,
          "/poster.jpg",
          "2021-01-01",
          200000000,
          120,
          "Released",
          "Tagline",
          "Title",
          false,
          7.8,
          1000,
        ]);
      });

      test('should be equal when all properties are the same', () {
        // arrange
        final tMovieDetailResponse1 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [tGenreModel],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        final tMovieDetailResponse2 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [tGenreModel],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        // assert
        expect(tMovieDetailResponse1, equals(tMovieDetailResponse2));
      });

      test('should not be equal when id is different', () {
        // arrange
        final tMovieDetailResponse1 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [tGenreModel],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        final tMovieDetailResponse2 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [tGenreModel],
          homepage: "https://example.com",
          id: 2,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        // assert
        expect(tMovieDetailResponse1, isNot(equals(tMovieDetailResponse2)));
      });

      test('should not be equal when title is different', () {
        // arrange
        final tMovieDetailResponse1 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [tGenreModel],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title 1",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        final tMovieDetailResponse2 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [tGenreModel],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title 2",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        // assert
        expect(tMovieDetailResponse1, isNot(equals(tMovieDetailResponse2)));
      });

      test('should not be equal when genres are different', () {
        // arrange
        final tMovieDetailResponse1 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [GenreModel(id: 1, name: "Action")],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        final tMovieDetailResponse2 = MovieDetailResponse(
          adult: false,
          backdropPath: "/path.jpg",
          budget: 100000000,
          genres: [GenreModel(id: 2, name: "Drama")],
          homepage: "https://example.com",
          id: 1,
          imdbId: "tt1234567",
          originalLanguage: "en",
          originalTitle: "Original Title",
          overview: "Overview",
          popularity: 123.456,
          posterPath: "/poster.jpg",
          releaseDate: "2021-01-01",
          revenue: 200000000,
          runtime: 120,
          status: "Released",
          tagline: "Tagline",
          title: "Title",
          video: false,
          voteAverage: 7.8,
          voteCount: 1000,
        );

        // assert
        expect(tMovieDetailResponse1, isNot(equals(tMovieDetailResponse2)));
      });
    });
  });
}
