import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_popular_tv_series.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';
import '../../domain/usecases/get_on_the_air_tv_series.dart';

// Events
abstract class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvSeries extends TvSeriesListEvent {}

class FetchTopRatedTvSeries extends TvSeriesListEvent {}

class FetchOnTheAirTvSeries extends TvSeriesListEvent {}

// State
class TvSeriesListState extends Equatable {
  final List<TvSeries> popularTvSeries;
  final List<TvSeries> topRatedTvSeries;
  final List<TvSeries> onTheAirTvSeries;
  final String popularMessage;
  final String topRatedMessage;
  final String onTheAirMessage;
  final bool isPopularLoading;
  final bool isTopRatedLoading;
  final bool isOnTheAirLoading;

  const TvSeriesListState({
    this.popularTvSeries = const [],
    this.topRatedTvSeries = const [],
    this.onTheAirTvSeries = const [],
    this.popularMessage = '',
    this.topRatedMessage = '',
    this.onTheAirMessage = '',
    this.isPopularLoading = false,
    this.isTopRatedLoading = false,
    this.isOnTheAirLoading = false,
  });

  TvSeriesListState copyWith({
    List<TvSeries>? popularTvSeries,
    List<TvSeries>? topRatedTvSeries,
    List<TvSeries>? onTheAirTvSeries,
    String? popularMessage,
    String? topRatedMessage,
    String? onTheAirMessage,
    bool? isPopularLoading,
    bool? isTopRatedLoading,
    bool? isOnTheAirLoading,
  }) {
    return TvSeriesListState(
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      onTheAirTvSeries: onTheAirTvSeries ?? this.onTheAirTvSeries,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
      onTheAirMessage: onTheAirMessage ?? this.onTheAirMessage,
      isPopularLoading: isPopularLoading ?? this.isPopularLoading,
      isTopRatedLoading: isTopRatedLoading ?? this.isTopRatedLoading,
      isOnTheAirLoading: isOnTheAirLoading ?? this.isOnTheAirLoading,
    );
  }

  @override
  List<Object> get props => [
        popularTvSeries,
        topRatedTvSeries,
        onTheAirTvSeries,
        popularMessage,
        topRatedMessage,
        onTheAirMessage,
        isPopularLoading,
        isTopRatedLoading,
        isOnTheAirLoading,
      ];
}

// BLoC
class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;
  final GetOnTheAirTvSeries getOnTheAirTvSeries;

  TvSeriesListBloc({
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
    required this.getOnTheAirTvSeries,
  }) : super(const TvSeriesListState()) {
    on<FetchPopularTvSeries>(_onFetchPopular);
    on<FetchTopRatedTvSeries>(_onFetchTopRated);
    on<FetchOnTheAirTvSeries>(_onFetchOnTheAir);
  }

  Future<void> _onFetchPopular(
    FetchPopularTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(isPopularLoading: true));
    
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        isPopularLoading: false,
        popularMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        isPopularLoading: false,
        popularTvSeries: data,
      )),
    );
  }

  Future<void> _onFetchTopRated(
    FetchTopRatedTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(isTopRatedLoading: true));
    
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        isTopRatedLoading: false,
        topRatedMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        isTopRatedLoading: false,
        topRatedTvSeries: data,
      )),
    );
  }

  Future<void> _onFetchOnTheAir(
    FetchOnTheAirTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(isOnTheAirLoading: true));
    
    final result = await getOnTheAirTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        isOnTheAirLoading: false,
        onTheAirMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        isOnTheAirLoading: false,
        onTheAirTvSeries: data,
      )),
    );
  }
}
