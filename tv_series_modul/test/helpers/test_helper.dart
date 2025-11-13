import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:ditonton_tv_series/data/datasources/db/database_helper.dart';
import 'package:ditonton_tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton_tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton_tv_series/domain/repositories/tv_series_repository.dart';

@GenerateMocks([
  TvSeriesRepository,
  TvSeriesRemoteDataSource,
  TvSeriesLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
