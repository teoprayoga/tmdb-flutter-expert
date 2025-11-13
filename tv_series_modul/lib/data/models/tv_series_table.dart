import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';

class TvSeriesTable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;

  TvSeriesTable({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) {
    return TvSeriesTable(
      id: tvSeries.id,
      name: tvSeries.name,
      overview: tvSeries.overview,
      posterPath: tvSeries.posterPath,
    );
  }

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) {
    return TvSeriesTable(
      id: map['id'] as int,
      name: map['name'] as String,
      overview: map['overview'] as String,
      posterPath: map['posterPath'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'posterPath': posterPath,
    };
  }

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      voteAverage: 0.0,
      voteCount: 0,
      firstAirDate: '',
      originCountry: [],
      genreIds: [],
    );
  }
}
