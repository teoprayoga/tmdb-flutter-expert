import 'package:equatable/equatable.dart';

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
