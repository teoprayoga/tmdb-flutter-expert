import '../../domain/entities/season.dart';

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
