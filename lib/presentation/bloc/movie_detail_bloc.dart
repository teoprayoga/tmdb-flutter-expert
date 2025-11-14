import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_movie_recommendations.dart';
import '../../domain/usecases/get_watchlist_status.dart';
import '../../domain/usecases/remove_watchlist.dart';
import '../../domain/usecases/save_watchlist.dart';

// Events
abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class LoadMovieWatchlistStatus extends MovieDetailEvent {
  final int id;

  const LoadMovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

// State
class MovieDetailState extends Equatable {
  final MovieDetail? movieDetail;
  final List<Movie> recommendations;
  final bool isLoading;
  final bool isRecommendationsLoading;
  final String message;
  final String recommendationsMessage;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    this.movieDetail,
    this.recommendations = const [],
    this.isLoading = false,
    this.isRecommendationsLoading = false,
    this.message = '',
    this.recommendationsMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    List<Movie>? recommendations,
    bool? isLoading,
    bool? isRecommendationsLoading,
    String? message,
    String? recommendationsMessage,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
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
        movieDetail,
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
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchDetail);
    on<AddMovieToWatchlist>(_onAddToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadMovieWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      isRecommendationsLoading: true,
    ));

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationsResult = await getMovieRecommendations.execute(event.id);

    detailResult.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        message: failure.message,
      )),
      (data) {
        emit(state.copyWith(
          isLoading: false,
          movieDetail: data,
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
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);

    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(state.copyWith(
        watchlistMessage: successMessage,
        isAddedToWatchlist: true,
      )),
    );

    add(LoadMovieWatchlistStatus(event.movie.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);

    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(state.copyWith(
        watchlistMessage: successMessage,
        isAddedToWatchlist: false,
      )),
    );

    add(LoadMovieWatchlistStatus(event.movie.id));
  }

  Future<void> _onLoadWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(
      isAddedToWatchlist: result,
      watchlistMessage: '',
    ));
  }
}
