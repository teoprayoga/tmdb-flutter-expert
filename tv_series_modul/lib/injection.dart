import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor_plus/http_interceptor_plus.dart';

import 'data/datasources/db/database_helper.dart' as tv_db;
import 'data/datasources/tv_series_local_data_source.dart';
import 'data/datasources/tv_series_remote_data_source.dart';
import 'data/repositories/tv_series_repository_impl.dart';
import 'domain/repositories/tv_series_repository.dart';
import 'domain/usecases/get_on_the_air_tv_series.dart';
import 'domain/usecases/get_popular_tv_series.dart';
import 'domain/usecases/get_top_rated_tv_series.dart';
import 'domain/usecases/get_tv_series_detail.dart';
import 'domain/usecases/get_tv_series_recommendations.dart';
import 'domain/usecases/get_watchlist_status.dart';
import 'domain/usecases/get_watchlist_tv_series.dart';
import 'domain/usecases/remove_watchlist.dart';
import 'domain/usecases/save_watchlist.dart';
import 'domain/usecases/search_tv_series.dart';
import 'presentation/bloc/search_tv_series_bloc.dart';
import 'presentation/bloc/tv_series_detail_bloc.dart';
import 'presentation/bloc/tv_series_list_bloc.dart';
import 'presentation/bloc/watchlist_tv_series_bloc.dart';

final locator = GetIt.instance;

void init({GetIt? l}) {
  var locator = l ?? GetIt.instance;

  // BLoC
  locator.registerFactory(
    () => TvSeriesListBloc(
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
      getOnTheAirTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailBloc(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchlistStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchTvSeriesBloc(
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesBloc(
      getWatchlistTvSeries: locator(),
    ),
  );

  // Use cases
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // Repository
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Data sources
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );

  // Helper
  locator.registerLazySingleton<tv_db.DatabaseHelper>(() => tv_db.DatabaseHelper());

  // External
  locator.registerLazySingleton(() => LoggingMiddleware(http.Client()) as http.Client);
}
