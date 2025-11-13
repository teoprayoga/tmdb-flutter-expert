import '../../domain/entities/tv_series.dart';

class TvSeriesModel {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? firstAirDate;
  final List<String> originCountry;
  final List<int> genreIds;

  TvSeriesModel({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.firstAirDate,
    required this.originCountry,
    required this.genreIds,
  });

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) {
    return TvSeriesModel(
      id: json['id'] as int,
      name: json['name'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
      firstAirDate: json['first_air_date'] as String?,
      originCountry: List<String>.from(json['origin_country'] ?? []),
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'first_air_date': firstAirDate,
      'origin_country': originCountry,
      'genre_ids': genreIds,
    };
  }

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath ?? '',
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      firstAirDate: firstAirDate ?? '',
      originCountry: originCountry,
      genreIds: genreIds,
    );
  }
}
