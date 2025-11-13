import 'dart:convert';

import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalTitle: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    title: "Title",
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tMovieResponseModel =
      MovieResponse(movieList: <MovieModel>[tMovieModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing.json'));
      // act
      final result = MovieResponse.fromJson(jsonMap);
      // assert
      expect(result, tMovieResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "original_title": "Original Title",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "release_date": "2020-05-05",
            "title": "Title",
            "video": false,
            "vote_average": 1.0,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });

    test('should convert to JSON and back correctly', () {
      // act
      final json = tMovieResponseModel.toJson();
      final result = MovieResponse.fromJson(json);

      // assert
      expect(result, tMovieResponseModel);
    });

    test('should handle empty movie list', () {
      // arrange
      final emptyResponse = MovieResponse(movieList: []);

      // act
      final result = emptyResponse.toJson();

      // assert
      expect(result['results'], []);
    });
  });

  group('Equatable', () {
    test('should be equal when movieList is the same', () {
      // arrange
      final response1 = MovieResponse(movieList: <MovieModel>[tMovieModel]);
      final response2 = MovieResponse(movieList: <MovieModel>[tMovieModel]);

      // assert
      expect(response1, equals(response2));
    });

    test('should not be equal when movieList is different', () {
      // arrange
      final response1 = MovieResponse(movieList: <MovieModel>[tMovieModel]);
      final response2 = MovieResponse(movieList: <MovieModel>[]);

      // assert
      expect(response1, isNot(equals(response2)));
    });

    test('should have correct props', () {
      // assert
      expect(tMovieResponseModel.props, [tMovieResponseModel.movieList]);
    });
  });

  group('fromJson - edge cases', () {
    test('should filter out movies without posterPath', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "original_title": "Original Title",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": null,
            "release_date": "2020-05-05",
            "title": "Title",
            "video": false,
            "vote_average": 1.0,
            "vote_count": 1
          },
          {
            "adult": false,
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 2,
            "original_title": "Original Title 2",
            "overview": "Overview 2",
            "popularity": 1.0,
            "poster_path": "/path2.jpg",
            "release_date": "2020-05-05",
            "title": "Title 2",
            "video": false,
            "vote_average": 1.0,
            "vote_count": 1
          }
        ]
      };

      // act
      final result = MovieResponse.fromJson(jsonMap);

      // assert
      expect(result.movieList.length, 1);
      expect(result.movieList[0].id, 2);
    });

    test('should handle empty results array', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "results": []
      };

      // act
      final result = MovieResponse.fromJson(jsonMap);

      // assert
      expect(result.movieList, []);
    });
  });
}
