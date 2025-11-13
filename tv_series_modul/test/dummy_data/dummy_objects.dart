import 'package:ditonton_tv_series/data/models/tv_series_detail_model.dart';
import 'package:ditonton_tv_series/data/models/tv_series_model.dart';
import 'package:ditonton_tv_series/domain/entities/tv_series.dart';
import 'package:ditonton_tv_series/domain/entities/tv_series_detail.dart';

final testTvSeriesModel = TvSeriesModel(
  id: 1,
  name: "Test TV Series",
  overview: "Test Overview",
  posterPath: "/test.jpg",
  backdropPath: "/test_backdrop.jpg",
  voteAverage: 7.5,
  voteCount: 100,
  firstAirDate: "2024-01-01",
  originCountry: ["US"],
  genreIds: [1, 2],
);

final testTvSeries = TvSeries(
  id: 1,
  name: 'Test TV Series',
  overview: 'Test Overview',
  posterPath: '/test.jpg',
  backdropPath: '/test_backdrop.jpg',
  voteAverage: 7.5,
  voteCount: 100,
  firstAirDate: '2024-01-01',
  originCountry: const ['US'],
  genreIds: const [1, 2],
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetailModel = TvSeriesDetailModel(
  id: 1,
  name: 'Test TV Series',
  overview: 'Test Overview',
  posterPath: '/test.jpg',
  backdropPath: '/test_backdrop.jpg',
  voteAverage: 7.5,
  voteCount: 100,
  firstAirDate: '2024-01-01',
  lastAirDate: '2024-12-31',
  genres: [
    GenreModel(id: 1, name: 'Drama'),
    GenreModel(id: 2, name: 'Comedy'),
  ],
  numberOfSeasons: 2,
  numberOfEpisodes: 20,
  seasons: [
    SeasonModel(
      id: 1,
      name: 'Season 1',
      seasonNumber: 1,
      episodeCount: 10,
      posterPath: '/season1.jpg',
      airDate: '2024-01-01',
      overview: 'First season',
    ),
  ],
  status: 'Returning Series',
  type: 'Scripted',
  inProduction: true,
  originCountry: ['US'],
);

final testTvSeriesDetail = TvSeriesDetail(
  id: 1,
  name: 'Test TV Series',
  overview: 'Test Overview',
  posterPath: '/test.jpg',
  backdropPath: '/test_backdrop.jpg',
  voteAverage: 7.5,
  voteCount: 100,
  firstAirDate: '2024-01-01',
  lastAirDate: '2024-12-31',
  genres: const [
    Genre(id: 1, name: 'Drama'),
    Genre(id: 2, name: 'Comedy'),
  ],
  numberOfSeasons: 2,
  numberOfEpisodes: 20,
  seasons: const [
    Season(
      id: 1,
      name: 'Season 1',
      seasonNumber: 1,
      episodeCount: 10,
      posterPath: '/season1.jpg',
      airDate: '2024-01-01',
      overview: 'First season',
    ),
  ],
  status: 'Returning Series',
  type: 'Scripted',
  inProduction: true,
  originCountry: const ['US'],
);
