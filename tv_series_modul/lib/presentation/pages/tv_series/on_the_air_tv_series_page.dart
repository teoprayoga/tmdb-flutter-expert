import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/tv_series_list_bloc.dart';
import '../../widgets/tv_series_card.dart';

class OnTheAirTvSeriesPage extends StatefulWidget {
  static const routeName = '/on-the-air-tv-series';

  const OnTheAirTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<OnTheAirTvSeriesPage> createState() => _OnTheAirTvSeriesPageState();
}

class _OnTheAirTvSeriesPageState extends State<OnTheAirTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesListBloc>().add(FetchOnTheAirTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
          builder: (context, state) {
            if (state.isOnTheAirLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.onTheAirMessage.isNotEmpty) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.onTheAirMessage),
              );
            } else if (state.onTheAirTvSeries.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.onTheAirTvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.onTheAirTvSeries.length,
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
