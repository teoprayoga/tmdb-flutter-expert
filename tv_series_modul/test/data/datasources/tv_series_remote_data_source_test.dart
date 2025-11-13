import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series_modul/common/exception.dart';
import 'package:tv_series_modul/data/datasources/tv_series_remote_data_source.dart';
import 'package:tv_series_modul/data/models/tv_series_detail_model.dart';
import 'package:tv_series_modul/data/models/tv_series_model.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getPopularTvSeries', () {
    final tTvSeriesList = [testTvSeriesModel];

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode({
            'results': [testTvSeriesModel.toJson()]
          }),
          200,
        ),
      );

      // act
      final result = await dataSource.getPopularTvSeries();

      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      // act
      final call = dataSource.getPopularTvSeries();

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTopRatedTvSeries', () {
    final tTvSeriesList = [testTvSeriesModel];

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode({
            'results': [testTvSeriesModel.toJson()]
          }),
          200,
        ),
      );

      // act
      final result = await dataSource.getTopRatedTvSeries();

      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      // act
      final call = dataSource.getTopRatedTvSeries();

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getOnTheAirTvSeries', () {
    final tTvSeriesList = [testTvSeriesModel];

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode({
            'results': [testTvSeriesModel.toJson()]
          }),
          200,
        ),
      );

      // act
      final result = await dataSource.getOnTheAirTvSeries();

      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      // act
      final call = dataSource.getOnTheAirTvSeries();

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTvSeriesDetail', () {
    const tId = 1;
    final tTvSeriesDetail = testTvSeriesDetailModel;

    test('should return TvSeriesDetailModel when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(testTvSeriesDetailModel.toJson()),
          200,
        ),
      );

      // act
      final result = await dataSource.getTvSeriesDetail(tId);

      // assert
      expect(result, equals(tTvSeriesDetail));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      // act
      final call = dataSource.getTvSeriesDetail(tId);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTvSeriesRecommendations', () {
    const tId = 1;
    final tTvSeriesList = [testTvSeriesModel];

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode({
            'results': [testTvSeriesModel.toJson()]
          }),
          200,
        ),
      );

      // act
      final result = await dataSource.getTvSeriesRecommendations(tId);

      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      // act
      final call = dataSource.getTvSeriesRecommendations(tId);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('searchTvSeries', () {
    const tQuery = 'Breaking Bad';
    final tTvSeriesList = [testTvSeriesModel];

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode({
            'results': [testTvSeriesModel.toJson()]
          }),
          200,
        ),
      );

      // act
      final result = await dataSource.searchTvSeries(tQuery);

      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      // act
      final call = dataSource.searchTvSeries(tQuery);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
