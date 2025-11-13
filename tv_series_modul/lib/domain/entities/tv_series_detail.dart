import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int id;
  final String name;

  const Genre({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}

class Season extends Equatable {
  final int id;
  final String name;
  final int seasonNumber;
  final int episodeCount;
  final String? posterPath;
  final String? airDate;
  final String overview;

  const Season({
    required this.id,
    required this.name,
    required this.seasonNumber,
    required this.episodeCount,
    this.posterPath,
    this.airDate,
    required this.overview,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        seasonNumber,
        episodeCount,
        posterPath,
        airDate,
        overview,
      ];
}

class TvSeriesDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String firstAirDate;
  final String? lastAirDate;
  final List<Genre> genres;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<Season> seasons;
  final String status;
  final String type;
  final bool inProduction;
  final List<String> originCountry;

  const TvSeriesDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    this.lastAirDate,
    required this.genres,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.seasons,
    required this.status,
    required this.type,
    required this.inProduction,
    required this.originCountry,
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
        lastAirDate,
        genres,
        numberOfSeasons,
        numberOfEpisodes,
        seasons,
        status,
        type,
        inProduction,
        originCountry,
      ];
}
