import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_watchlist_tv_series.dart';

// Events
abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {}

// State
abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistTvSeriesState {}

class WatchlistLoading extends WatchlistTvSeriesState {}

class WatchlistError extends WatchlistTvSeriesState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistHasData extends WatchlistTvSeriesState {
  final List<TvSeries> result;

  const WatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

// BLoC
class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc({required this.getWatchlistTvSeries})
      : super(WatchlistEmpty()) {
    on<FetchWatchlistTvSeries>(_onFetchWatchlist);
  }

  Future<void> _onFetchWatchlist(
    FetchWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(WatchlistLoading());

    final result = await getWatchlistTvSeries.execute();

    result.fold(
      (failure) => emit(WatchlistError(failure.message)),
      (data) {
        if (data.isEmpty) {
          emit(WatchlistEmpty());
        } else {
          emit(WatchlistHasData(data));
        }
      },
    );
  }
}
