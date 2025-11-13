import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String firstAirDate;
  final List<String> originCountry;
  final List<int> genreIds;

  const TvSeries({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    required this.originCountry,
    required this.genreIds,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        firstAirDate,
        originCountry,
        genreIds,
      ];
}
