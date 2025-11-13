import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/tv_series_list_bloc.dart';
import '../../widgets/tv_series_card.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const routeName = '/popular-tv-series';

  const PopularTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesListBloc>().add(FetchPopularTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
          builder: (context, state) {
            if (state.isPopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.popularMessage.isNotEmpty) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.popularMessage),
              );
            } else if (state.popularTvSeries.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.popularTvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.popularTvSeries.length,
              );
            } else {
              return const Center(
                child: Text('No data'),
              );
            }
          },
        ),
      ),
    );
  }
}
