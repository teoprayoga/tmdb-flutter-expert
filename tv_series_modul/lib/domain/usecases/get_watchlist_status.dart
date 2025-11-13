import '../repositories/tv_series_repository.dart';

class GetWatchlistStatus {
  final TvSeriesRepository repository;

  GetWatchlistStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
