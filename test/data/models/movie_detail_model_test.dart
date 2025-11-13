import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: "Action");

  final tSeasonModel = SeasonModel(
    airDate: "2021-01-01",
    episodeCount: 10,
    id: 1,
    name: "Season 1",
    overview: "The first season",
    posterPath: "/season.jpg",
    seasonNumber: 1,
  );

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
    seasons: null, // ⭐ Added seasons field
  );

  group('MovieDetailResponse', () {
    test('should be a subclass of MovieDetail entity', () {
      // assert
      expect(tMovieDetailResponse.toEntity(), isA<MovieDetail>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON without seasons', () {
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
        expect(result.seasons, null);
      });

      test('should return a valid model from JSON with seasons', () {
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
          "seasons": [
            {
              "air_date": "2021-01-01",
              "episode_count": 10,
              "id": 1,
              "name": "Season 1",
              "overview": "The first season",
              "poster_path": "/season.jpg",
              "season_number": 1,
            }
          ],
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result.seasons, isNotNull);
        expect(result.seasons!.length, 1);
        expect(result.seasons![0].seasonNumber, 1);
        expect(result.seasons![0].episodeCount, 10);
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
          "seasons": null,
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result.backdropPath, null);
        expect(result.imdbId, null);
        expect(result.genres, []);
        expect(result.seasons, null);
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

      test('should parse multiple seasons correctly', () {
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
          "seasons": [
            {
              "air_date": "2021-01-01",
              "episode_count": 10,
              "id": 1,
              "name": "Season 1",
              "overview": "The first season",
              "poster_path": "/season1.jpg",
              "season_number": 1,
            },
            {
              "air_date": "2022-01-01",
              "episode_count": 12,
              "id": 2,
              "name": "Season 2",
              "overview": "The second season",
              "poster_path": "/season2.jpg",
              "season_number": 2,
            }
          ],
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result.seasons, isNotNull);
        expect(result.seasons!.length, 2);
        expect(result.seasons![0].seasonNumber, 1);
        expect(result.seasons![0].episodeCount, 10);
        expect(result.seasons![1].seasonNumber, 2);
        expect(result.seasons![1].episodeCount, 12);
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
          "seasons": null, // ⭐ Added seasons field
          "number_of_seasons": 0,
          "number_of_episodes": 0,
          "type": '',
          "in_production": false,
          "first_air_date": null,
          "last_air_date": null,
        };
        expect(result, equals(expectedJsonMap));
      });

      test('should return a JSON map with seasons data', () {
        // arrange
        final movieWithSeasons = MovieDetailResponse(
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
          seasons: [tSeasonModel],
        );

        // act
        final result = movieWithSeasons.toJson();

        // assert
        expect(result["seasons"], isNotNull);
        expect(result["seasons"], isA<List>());
        expect((result["seasons"] as List).length, 1);
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
          seasons: null,
        );

        // act
        final result = movieWithNulls.toJson();

        // assert
        expect(result["backdrop_path"], null);
        expect(result["imdb_id"], null);
        expect(result["genres"], []);
        expect(result["seasons"], null);
      });

      test('should convert to JSON and back to model correctly', () {
        // act
        final json = tMovieDetailResponse.toJson();
        final result = MovieDetailResponse.fromJson(json);

        // assert
        expect(result, equals(tMovieDetailResponse));
      });

      test('should convert to JSON and back with seasons correctly', () {
        // arrange
        final movieWithSeasons = MovieDetailResponse(
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
          seasons: [tSeasonModel],
        );

        // act
        final json = movieWithSeasons.toJson();
        final result = MovieDetailResponse.fromJson(json);

        // assert
        expect(result, equals(movieWithSeasons));
        expect(result.seasons, isNotNull);
        expect(result.seasons!.length, 1);
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
        expect(result.containsKey("seasons"), true); // ⭐ Added seasons key check
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

      test('should return empty list for seasons when null', () {
        // act
        final result = tMovieDetailResponse.toEntity();

        // assert
        expect(result.seasons, []);
      });

      test('should map seasons to entities correctly', () {
        // arrange
        final movieWithSeasons = MovieDetailResponse(
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
          seasons: [tSeasonModel],
        );

        // act
        final result = movieWithSeasons.toEntity();

        // assert
        expect(result.seasons?.length, 1);
        expect(result.seasons?[0].seasonNumber, 1);
        expect(result.seasons?[0].episodeCount, 10);
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

      test('should handle multiple seasons in toEntity', () {
        // arrange
        final season1 = SeasonModel(
          airDate: "2021-01-01",
          episodeCount: 10,
          id: 1,
          name: "Season 1",
          overview: "First season",
          posterPath: "/s1.jpg",
          seasonNumber: 1,
        );
        final season2 = SeasonModel(
          airDate: "2022-01-01",
          episodeCount: 12,
          id: 2,
          name: "Season 2",
          overview: "Second season",
          posterPath: "/s2.jpg",
          seasonNumber: 2,
        );

        final movieWithMultipleSeasons = MovieDetailResponse(
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
          seasons: [season1, season2],
        );

        // act
        final result = movieWithMultipleSeasons.toEntity();

        // assert
        expect(result.seasons?.length, 2);
        expect(result.seasons?[0].seasonNumber, 1);
        expect(result.seasons?[1].seasonNumber, 2);
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
          seasons: null,
        );

        // act
        final result = movieWithNulls.toEntity();

        // assert
        expect(result.backdropPath, null);
        expect(result.genres, []);
        expect(result.seasons, []);
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
