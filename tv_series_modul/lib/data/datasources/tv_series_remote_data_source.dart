import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/exception.dart';
import '../../env.dart';
import '../models/tv_series_detail_model.dart';
import '../models/tv_series_model.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<List<TvSeriesModel>> getOnTheAirTvSeries();
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  static const apiKey = Env.apiKey;
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/popular?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return (result['results'] as List).map((data) => TvSeriesModel.fromJson(data)).toList();
    } else {
      throw ServerException('Failed to load popular TV series');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/top_rated?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return (result['results'] as List).map((data) => TvSeriesModel.fromJson(data)).toList();
    } else {
      throw ServerException('Failed to load top rated TV series');
    }
  }

  @override
  Future<List<TvSeriesModel>> getOnTheAirTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/on_the_air?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return (result['results'] as List).map((data) => TvSeriesModel.fromJson(data)).toList();
    } else {
      throw ServerException('Failed to load on the air TV series');
    }
  }

  @override
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return TvSeriesDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to load TV series detail');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id/recommendations?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return (result['results'] as List).map((data) => TvSeriesModel.fromJson(data)).toList();
    } else {
      throw ServerException('Failed to load recommendations');
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return (result['results'] as List).map((data) => TvSeriesModel.fromJson(data)).toList();
    } else {
      throw ServerException('Failed to search TV series');
    }
  }
}
