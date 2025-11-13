import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart' as di;
import 'presentation/bloc/search_tv_series_bloc.dart';
import 'presentation/bloc/tv_series_detail_bloc.dart';
import 'presentation/bloc/tv_series_list_bloc.dart';
import 'presentation/bloc/watchlist_tv_series_bloc.dart';
import 'presentation/pages/tv_series/home_tv_series_page.dart';
import 'presentation/pages/tv_series/on_the_air_tv_series_page.dart';
import 'presentation/pages/tv_series/popular_tv_series_page.dart';
import 'presentation/pages/tv_series/search_tv_series_page.dart';
import 'presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'presentation/pages/tv_series/tv_series_detail_page.dart';
import 'presentation/pages/tv_series/watchlist_tv_series_page.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<TvSeriesListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'TV Series App',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.grey[900],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
          ),
        ),
        home: const HomeTvSeriesPage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case PopularTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const PopularTvSeriesPage(),
              );
            case TopRatedTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const TopRatedTvSeriesPage(),
              );
            case OnTheAirTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const OnTheAirTvSeriesPage(),
              );
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
              );
            case SearchTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const SearchTvSeriesPage(),
              );
            case WatchlistTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistTvSeriesPage(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
