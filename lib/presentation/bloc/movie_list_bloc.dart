import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_now_playing_movies.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';

// Events
abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends MovieListEvent {}

class FetchPopularMovies extends MovieListEvent {}

class FetchTopRatedMovies extends MovieListEvent {}

// State
class MovieListState extends Equatable {
  final List<Movie> nowPlayingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final String nowPlayingMessage;
  final String popularMessage;
  final String topRatedMessage;
  final bool isNowPlayingLoading;
  final bool isPopularLoading;
  final bool isTopRatedLoading;

  const MovieListState({
    this.nowPlayingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.nowPlayingMessage = '',
    this.popularMessage = '',
    this.topRatedMessage = '',
    this.isNowPlayingLoading = false,
    this.isPopularLoading = false,
    this.isTopRatedLoading = false,
  });

  MovieListState copyWith({
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    String? nowPlayingMessage,
    String? popularMessage,
    String? topRatedMessage,
    bool? isNowPlayingLoading,
    bool? isPopularLoading,
    bool? isTopRatedLoading,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      nowPlayingMessage: nowPlayingMessage ?? this.nowPlayingMessage,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
      isNowPlayingLoading: isNowPlayingLoading ?? this.isNowPlayingLoading,
      isPopularLoading: isPopularLoading ?? this.isPopularLoading,
      isTopRatedLoading: isTopRatedLoading ?? this.isTopRatedLoading,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingMovies,
        popularMovies,
        topRatedMovies,
        nowPlayingMessage,
        popularMessage,
        topRatedMessage,
        isNowPlayingLoading,
        isPopularLoading,
        isTopRatedLoading,
      ];
}

// BLoC
class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlaying);
    on<FetchPopularMovies>(_onFetchPopular);
    on<FetchTopRatedMovies>(_onFetchTopRated);
  }

  Future<void> _onFetchNowPlaying(
    FetchNowPlayingMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(isNowPlayingLoading: true));

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        isNowPlayingLoading: false,
        nowPlayingMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        isNowPlayingLoading: false,
        nowPlayingMovies: data,
      )),
    );
  }

  Future<void> _onFetchPopular(
    FetchPopularMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(isPopularLoading: true));

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        isPopularLoading: false,
        popularMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        isPopularLoading: false,
        popularMovies: data,
      )),
    );
  }

  Future<void> _onFetchTopRated(
    FetchTopRatedMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(isTopRatedLoading: true));

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        isTopRatedLoading: false,
        topRatedMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        isTopRatedLoading: false,
        topRatedMovies: data,
      )),
    );
  }
}
