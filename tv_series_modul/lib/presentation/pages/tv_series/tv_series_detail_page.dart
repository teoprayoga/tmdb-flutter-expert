import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../domain/entities/tv_series.dart';
import '../../../domain/entities/tv_series_detail.dart';
import '../../bloc/tv_series_detail_bloc.dart';
import '../../widgets/tv_series_card.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = '/tv-series-detail';
  final int id;

  const TvSeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
      context.read<TvSeriesDetailBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvSeriesDetailBloc, TvSeriesDetailState>(
        listener: (context, state) {
          if (state.watchlistMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.watchlistMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.message.isNotEmpty) {
            return Center(child: Text(state.message));
          } else if (state.tvSeriesDetail != null) {
            return SafeArea(
              child: DetailContent(
                tvSeries: state.tvSeriesDetail!,
                recommendations: state.recommendations,
                isAddedToWatchlist: state.isAddedToWatchlist,
              ),
            );
          } else {
            return const Center(child: Text('Failed to load data'));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;

  const DetailContent({
    Key? key,
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedToWatchlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (!isAddedToWatchlist) {
                                  context.read<TvSeriesDetailBloc>().add(AddToWatchlist(tvSeries));
                                } else {
                                  context.read<TvSeriesDetailBloc>().add(RemoveFromWatchlist(tvSeries));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(isAddedToWatchlist ? Icons.check : Icons.add),
                                  const SizedBox(width: 8),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _showGenres(tvSeries.genres),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemSize: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(tvSeries.voteAverage.toString()),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(tvSeries.overview),
                            const SizedBox(height: 16),
                            Text(
                              'Info',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow('Status', tvSeries.status),
                            _buildInfoRow('Type', tvSeries.type),
                            _buildInfoRow(
                              'Seasons',
                              tvSeries.numberOfSeasons.toString(),
                            ),
                            _buildInfoRow(
                              'Episodes',
                              tvSeries.numberOfEpisodes.toString(),
                            ),
                            _buildInfoRow('First Air Date', tvSeries.firstAirDate),
                            if (tvSeries.lastAirDate != null) _buildInfoRow('Last Air Date', tvSeries.lastAirDate!),
                            const SizedBox(height: 16),
                            if (tvSeries.seasons.isNotEmpty) ...[
                              Text(
                                'Seasons',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              ...tvSeries.seasons.map((season) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: season.posterPath != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://image.tmdb.org/t/p/w92${season.posterPath}',
                                              width: 50,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => const SizedBox(
                                                width: 50,
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          )
                                        : Container(
                                            width: 50,
                                            height: 75,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image),
                                          ),
                                    title: Text(season.name),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${season.episodeCount} Episodes',
                                        ),
                                        if (season.airDate != null)
                                          Text(
                                            'Air Date: ${season.airDate}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
                              builder: (context, state) {
                                if (state.isRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.recommendationsMessage.isNotEmpty) {
                                  return Center(
                                    child: Text(state.recommendationsMessage),
                                  );
                                } else if (recommendations.isEmpty) {
                                  return const Center(
                                    child: Text('No recommendations'),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recommendations.length,
                                      itemBuilder: (context, index) {
                                        final tvSeries = recommendations[index];
                                        return TvSeriesCard(tvSeries);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
            maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
