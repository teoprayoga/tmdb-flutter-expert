const tvSeriesListJson = {
  "results": [
    {
      "id": 1,
      "name": "Test TV Series",
      "overview": "Test Overview",
      "poster_path": "/test.jpg",
      "backdrop_path": "/test_backdrop.jpg",
      "vote_average": 7.5,
      "vote_count": 100,
      "first_air_date": "2024-01-01",
      "origin_country": ["US"],
      "genre_ids": [1, 2]
    }
  ]
};

const tvSeriesDetailJson = {
  "id": 1,
  "name": "Test TV Series",
  "overview": "Test Overview",
  "poster_path": "/test.jpg",
  "backdrop_path": "/test_backdrop.jpg",
  "vote_average": 7.5,
  "vote_count": 100,
  "first_air_date": "2024-01-01",
  "last_air_date": "2024-12-31",
  "genres": [
    {"id": 1, "name": "Drama"},
    {"id": 2, "name": "Comedy"}
  ],
  "number_of_seasons": 2,
  "number_of_episodes": 20,
  "seasons": [
    {
      "id": 1,
      "name": "Season 1",
      "season_number": 1,
      "episode_count": 10,
      "poster_path": "/season1.jpg",
      "air_date": "2024-01-01",
      "overview": "First season"
    }
  ],
  "status": "Returning Series",
  "type": "Scripted",
  "in_production": true,
  "origin_country": ["US"]
};
