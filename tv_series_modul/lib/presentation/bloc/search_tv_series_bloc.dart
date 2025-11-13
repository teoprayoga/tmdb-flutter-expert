import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/search_tv_series.dart';

// Events
abstract class SearchTvSeriesEvent extends Equatable {
  const SearchTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchTvSeriesEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

// State
abstract class SearchTvSeriesState extends Equatable {
  const SearchTvSeriesState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchTvSeriesState {}

class SearchLoading extends SearchTvSeriesState {}

class SearchError extends SearchTvSeriesState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchTvSeriesState {
  final List<TvSeries> result;

  const SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}

// BLoC
class SearchTvSeriesBloc
    extends Bloc<SearchTvSeriesEvent, SearchTvSeriesState> {
  final SearchTvSeries searchTvSeries;

  SearchTvSeriesBloc({required this.searchTvSeries})
      : super(SearchEmpty()) {
    on<OnQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onQueryChanged(
    OnQueryChanged event,
    Emitter<SearchTvSeriesState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(SearchEmpty());
      return;
    }

    emit(SearchLoading());

    final result = await searchTvSeries.execute(query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (data) => emit(SearchHasData(data)),
    );
  }
}
