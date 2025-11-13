import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_recommendations.dart';
import '../../domain/usecases/get_watchlist_status.dart';
import '../../domain/usecases/save_watchlist.dart';
import '../../domain/usecases/remove_watchlist.dart';

// Events
abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveFromWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class LoadWatchlistStatus extends TvSeriesDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

// State
class TvSeriesDetailState extends Equatable {
  final TvSeriesDetail? tvSeriesDetail;
  final List<TvSeries> recommendations;
  final bool isLoading;
  final bool isRecommendationsLoading;
  final String message;
  final String recommendationsMessage;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvSeriesDetailState({
    this.tvSeriesDetail,
    this.recommendations = const [],
    this.isLoading = false,
    this.isRecommendationsLoading = false,
    this.message = '',
    this.recommendationsMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeriesDetail,
    List<TvSeries>? recommendations,
    bool? isLoading,
    bool? isRecommendationsLoading,
    String? message,
    String? recommendationsMessage,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      isRecommendationsLoading:
          isRecommendationsLoading ?? this.isRecommendationsLoading,
      message: message ?? this.message,
      recommendationsMessage:
          recommendationsMessage ?? this.recommendationsMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeriesDetail,
        recommendations,
        isLoading,
        isRecommendationsLoading,
        message,
        recommendationsMessage,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}

// BLoC
class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatus getWatchlistStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>(_onFetchDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      isRecommendationsLoading: true,
    ));

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationsResult =
        await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        message: failure.message,
      )),
      (data) {
        emit(state.copyWith(
          isLoading: false,
          tvSeriesDetail: data,
        ));

        recommendationsResult.fold(
          (failure) => emit(state.copyWith(
            isRecommendationsLoading: false,
            recommendationsMessage: failure.message,
          )),
          (recommendations) => emit(state.copyWith(
            isRecommendationsLoading: false,
            recommendations: recommendations,
          )),
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvSeries);
    
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(state.copyWith(
        watchlistMessage: successMessage,
        isAddedToWatchlist: true,
      )),
    );

    add(LoadWatchlistStatus(event.tvSeries.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvSeries);
    
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(state.copyWith(
        watchlistMessage: successMessage,
        isAddedToWatchlist: false,
      )),
    );

    add(LoadWatchlistStatus(event.tvSeries.id));
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getWatchlistStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
