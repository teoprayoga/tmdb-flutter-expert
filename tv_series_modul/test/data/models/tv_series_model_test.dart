import 'package:ditonton_tv_series/data/models/tv_series_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group('fromJson', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "name": "Test TV Series",
        "overview": "Test Overview",
        "poster_path": "/test.jpg",
        "backdrop_path": "/test_backdrop.jpg",
        "vote_average": 7.5,
        "vote_count": 100,
        "first_air_date": "2024-01-01",
        "origin_country": ["US"],
        "genre_ids": [1, 2]
      };
      // act
      final result = TvSeriesModel.fromJson(jsonMap);
      // assert
      expect(result.toEntity(), testTvSeriesModel.toEntity());
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      // arrange
      final expectedJsonMap = {
        "id": 1,
        "name": "Test TV Series",
        "overview": "Test Overview",
        "poster_path": "/test.jpg",
        "backdrop_path": "/test_backdrop.jpg",
        "vote_average": 7.5,
        "vote_count": 100,
        "first_air_date": "2024-01-01",
        "origin_country": ["US"],
        "genre_ids": [1, 2]
      };
      // act
      final result = testTvSeriesModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should be a subclass of TvSeries entity', () {
      // act
      final result = testTvSeriesModel.toEntity();
      // assert
      expect(result, testTvSeries);
    });
  });
}
