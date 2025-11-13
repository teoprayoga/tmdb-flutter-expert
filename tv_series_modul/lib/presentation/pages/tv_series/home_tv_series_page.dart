import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/tv_series_list_bloc.dart';
import '../../widgets/tv_series_card.dart';
import 'on_the_air_tv_series_page.dart';
import 'popular_tv_series_page.dart';
import 'search_tv_series_page.dart';
import 'top_rated_tv_series_page.dart';
import 'watchlist_tv_series_page.dart';

class HomeTvSeriesPage extends StatefulWidget {
  const HomeTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<HomeTvSeriesPage> createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesListBloc>().add(FetchPopularTvSeries());
      context.read<TvSeriesListBloc>().add(FetchTopRatedTvSeries());
      context.read<TvSeriesListBloc>().add(FetchOnTheAirTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchTvSeriesPage.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.pushNamed(context, WatchlistTvSeriesPage.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: 'On The Air',
                onSeeMoreTapped: () {
                  Navigator.pushNamed(context, OnTheAirTvSeriesPage.routeName);
                },
                content: BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
                  builder: (context, state) {
                    if (state.isOnTheAirLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.onTheAirMessage.isNotEmpty) {
                      return Center(
                        child: Text(state.onTheAirMessage),
                      );
                    } else if (state.onTheAirTvSeries.isNotEmpty) {
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.onTheAirTvSeries.length,
                          itemBuilder: (context, index) {
                            final tvSeries = state.onTheAirTvSeries[index];
                            return TvSeriesCard(tvSeries);
                          },
                        ),
                      );
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Popular',
                onSeeMoreTapped: () {
                  Navigator.pushNamed(context, PopularTvSeriesPage.routeName);
                },
                content: BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
                  builder: (context, state) {
                    if (state.isPopularLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.popularMessage.isNotEmpty) {
                      return Center(
                        child: Text(state.popularMessage),
                      );
                    } else if (state.popularTvSeries.isNotEmpty) {
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.popularTvSeries.length,
                          itemBuilder: (context, index) {
                            final tvSeries = state.popularTvSeries[index];
                            return TvSeriesCard(tvSeries);
                          },
                        ),
                      );
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Top Rated',
                onSeeMoreTapped: () {
                  Navigator.pushNamed(context, TopRatedTvSeriesPage.routeName);
                },
                content: BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
                  builder: (context, state) {
                    if (state.isTopRatedLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.topRatedMessage.isNotEmpty) {
                      return Center(
                        child: Text(state.topRatedMessage),
                      );
                    } else if (state.topRatedTvSeries.isNotEmpty) {
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.topRatedTvSeries.length,
                          itemBuilder: (context, index) {
                            final tvSeries = state.topRatedTvSeries[index];
                            return TvSeriesCard(tvSeries);
                          },
                        ),
                      );
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onSeeMoreTapped,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onSeeMoreTapped,
              child: const Text('See More'),
            ),
          ],
        ),
        content,
      ],
    );
  }
}
