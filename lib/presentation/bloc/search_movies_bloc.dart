import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/search_movies.dart';

// Events
abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();

  @override
  List<Object> get props => [];
}

class OnMovieQueryChanged extends SearchMoviesEvent {
  final String query;

  const OnMovieQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

// State
abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object> get props => [];
}

class SearchMoviesEmpty extends SearchMoviesState {}

class SearchMoviesLoading extends SearchMoviesState {}

class SearchMoviesError extends SearchMoviesState {
  final String message;

  const SearchMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchMoviesHasData extends SearchMoviesState {
  final List<Movie> result;

  const SearchMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}

// BLoC
class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMovies searchMovies;

  SearchMoviesBloc({required this.searchMovies}) : super(SearchMoviesEmpty()) {
    on<OnMovieQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onQueryChanged(
    OnMovieQueryChanged event,
    Emitter<SearchMoviesState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(SearchMoviesEmpty());
      return;
    }

    emit(SearchMoviesLoading());

    final result = await searchMovies.execute(query);

    result.fold(
      (failure) => emit(SearchMoviesError(failure.message)),
      (data) => emit(SearchMoviesHasData(data)),
    );
  }
}
