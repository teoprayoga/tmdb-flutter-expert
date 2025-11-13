import '../../domain/entities/tv_series_detail.dart';

class GenreModel {
  final int id;
  final String name;

  GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Genre toEntity() {
    return Genre(
      id: id,
      name: name,
    );
  }
}

class SeasonModel {
  final int id;
  final String name;
  final int seasonNumber;
  final int episodeCount;
  final String? posterPath;
  final String? airDate;
  final String overview;

  SeasonModel({
    required this.id,
    required this.name,
    required this.seasonNumber,
    required this.episodeCount,
    this.posterPath,
    this.airDate,
    required this.overview,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      seasonNumber: json['season_number'] as int,
      episodeCount: json['episode_count'] as int,
      posterPath: json['poster_path'] as String?,
      airDate: json['air_date'] as String?,
      overview: json['overview'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'season_number': seasonNumber,
      'episode_count': episodeCount,
      'poster_path': posterPath,
      'air_date': airDate,
      'overview': overview,
    };
  }

  Season toEntity() {
    return Season(
      id: id,
      name: name,
      seasonNumber: seasonNumber,
      episodeCount: episodeCount,
      posterPath: posterPath,
      airDate: airDate,
      overview: overview,
    );
  }
}

class TvSeriesDetailModel {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? firstAirDate;
  final String? lastAirDate;
  final List<GenreModel> genres;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<SeasonModel> seasons;
  final String status;
  final String type;
  final bool inProduction;
  final List<String> originCountry;

  TvSeriesDetailModel({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.firstAirDate,
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

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) {
    return TvSeriesDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      firstAirDate: json['first_air_date'] as String?,
      lastAirDate: json['last_air_date'] as String?,
      genres: (json['genres'] as List?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      numberOfSeasons: json['number_of_seasons'] as int? ?? 0,
      numberOfEpisodes: json['number_of_episodes'] as int? ?? 0,
      seasons: (json['seasons'] as List?)
              ?.map((e) => SeasonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
      inProduction: json['in_production'] as bool? ?? false,
      originCountry: List<String>.from(json['origin_country'] ?? []),
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
      'last_air_date': lastAirDate,
      'genres': genres.map((e) => e.toJson()).toList(),
      'number_of_seasons': numberOfSeasons,
      'number_of_episodes': numberOfEpisodes,
      'seasons': seasons.map((e) => e.toJson()).toList(),
      'status': status,
      'type': type,
      'in_production': inProduction,
      'origin_country': originCountry,
    };
  }

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath ?? '',
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      firstAirDate: firstAirDate ?? '',
      lastAirDate: lastAirDate,
      genres: genres.map((e) => e.toEntity()).toList(),
      numberOfSeasons: numberOfSeasons,
      numberOfEpisodes: numberOfEpisodes,
      seasons: seasons.map((e) => e.toEntity()).toList(),
      status: status,
      type: type,
      inProduction: inProduction,
      originCountry: originCountry,
    );
  }
}
