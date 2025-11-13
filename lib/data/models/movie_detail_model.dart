import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

class MovieDetailResponse extends Equatable {
  MovieDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.seasons,
    this.numberOfSeasons = 0,
    this.numberOfEpisodes = 0,
    this.type = '',
    this.inProduction = false,
    this.firstAirDate,
    this.lastAirDate,
  });

  final bool adult;
  final String? backdropPath;
  final int budget;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String? imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final int revenue;
  final int runtime;
  final String status;
  final String tagline;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final List<SeasonModel>? seasons;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final String type;
  final bool inProduction;
  final String? firstAirDate;
  final String? lastAirDate;

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) => MovieDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        budget: json["budget"],
        genres: List<GenreModel>.from(json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        revenue: json["revenue"],
        runtime: json["runtime"],
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        seasons: json["seasons"] == null
            ? null
            : List<SeasonModel>.from(
                json["seasons"].map((x) => SeasonModel.fromJson(x)),
              ),
        numberOfSeasons: json["number_of_seasons"] ?? 0,
        numberOfEpisodes: json["number_of_episodes"] ?? 0,
        type: json["type"] ?? '',
        inProduction: json["in_production"] ?? false,
        firstAirDate: json["first_air_date"],
        lastAirDate: json["last_air_date"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "budget": budget,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "revenue": revenue,
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "seasons": seasons == null ? null : List<dynamic>.from(seasons!.map((x) => x.toJson())),
        "number_of_seasons": numberOfSeasons,
        "number_of_episodes": numberOfEpisodes,
        "type": type,
        "in_production": inProduction,
        "first_air_date": firstAirDate,
        "last_air_date": lastAirDate,
      };

  MovieDetail toEntity() {
    return MovieDetail(
      adult: this.adult,
      backdropPath: this.backdropPath,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      originalTitle: this.originalTitle,
      overview: this.overview,
      posterPath: this.posterPath,
      releaseDate: this.releaseDate,
      runtime: this.runtime,
      title: this.title,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
      seasons: this.seasons == null ? [] : this.seasons!.map((season) => season.toEntity()).toList(),
      numberOfSeasons: this.numberOfSeasons,
      numberOfEpisodes: this.numberOfEpisodes,
      type: this.type,
      inProduction: this.inProduction,
      firstAirDate: this.firstAirDate,
      lastAirDate: this.lastAirDate,
      status: this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        adult,
        backdropPath,
        budget,
        genres,
        homepage,
        id,
        imdbId,
        originalLanguage,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        revenue,
        runtime,
        status,
        tagline,
        title,
        video,
        voteAverage,
        voteCount,
      ];
}
