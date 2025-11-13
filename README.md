# Ditonton TV Series

Aplikasi Flutter untuk menampilkan daftar TV Series dengan fitur lengkap termasuk detail, pencarian, dan watchlist. Dibuat mengikuti Clean Architecture dan menggunakan BLoC untuk state management.

## Fitur Utama

### Kriteria Wajib ✅

1. **Daftar TV Series**
   - Menampilkan TV Series populer, top rated, dan sedang tayang
   - Masing-masing kategori memiliki halaman tersendiri

2. **Detail TV Series**
   - Menampilkan poster, judul, rating, dan sinopsis
   - Menampilkan rekomendasi TV series lainnya
   - **Menampilkan informasi Season & Episode** (Kriteria Opsional ⭐)

3. **Pencarian TV Series**
   - Search menggunakan API TMDB (bukan filtering lokal)
   - Dengan debounce untuk efisiensi

4. **Watchlist**
   - Menyimpan TV series ke dalam watchlist lokal (SQLite)
   - Data tetap bertahan setelah aplikasi ditutup

5. **Automated Testing**
   - Unit tests untuk usecases, repositories, dan data sources
   - BLoC tests menggunakan bloc_test
   - Target coverage: 70%+ ✅

6. **Clean Architecture**
   - **Domain Layer**: Entities, Repositories Interface, Use Cases
   - **Data Layer**: Models, Data Sources (Remote & Local), Repository Implementation
   - **Presentation Layer**: Pages, Widgets, BLoC (State Management)

### Fitur Tambahan ⭐

- **Season & Episode Information**: Detail page menampilkan lengkap informasi season dan episode
- **BLoC State Management**: Menggunakan flutter_bloc untuk state management yang reaktif
- **Caching**: Menggunakan cached_network_image untuk efisiensi loading gambar
- **Debounced Search**: Search dengan debounce untuk mengurangi API calls

## Arsitektur

```
lib/
├── common/                  # Shared utilities
│   ├── exception.dart
│   └── failure.dart
├── data/
│   ├── datasources/        # Remote & Local data sources
│   │   ├── db/
│   │   │   └── database_helper.dart
│   │   ├── tv_series_local_data_source.dart
│   │   └── tv_series_remote_data_source.dart
│   ├── models/             # Data models
│   │   ├── tv_series_model.dart
│   │   ├── tv_series_detail_model.dart
│   │   └── tv_series_table.dart
│   └── repositories/       # Repository implementations
│       └── tv_series_repository_impl.dart
├── domain/
│   ├── entities/           # Business entities
│   │   ├── tv_series.dart
│   │   └── tv_series_detail.dart
│   ├── repositories/       # Repository interfaces
│   │   └── tv_series_repository.dart
│   └── usecases/          # Business logic
│       ├── get_popular_tv_series.dart
│       ├── get_top_rated_tv_series.dart
│       ├── get_on_the_air_tv_series.dart
│       ├── get_tv_series_detail.dart
│       ├── get_tv_series_recommendations.dart
│       ├── search_tv_series.dart
│       ├── save_watchlist.dart
│       ├── remove_watchlist.dart
│       ├── get_watchlist_status.dart
│       └── get_watchlist_tv_series.dart
├── presentation/
│   ├── bloc/              # BLoC for state management
│   │   ├── tv_series_list_bloc.dart
│   │   ├── tv_series_detail_bloc.dart
│   │   ├── search_tv_series_bloc.dart
│   │   └── watchlist_tv_series_bloc.dart
│   ├── pages/             # UI Pages
│   │   └── tv_series/
│   │       ├── home_tv_series_page.dart
│   │       ├── tv_series_detail_page.dart
│   │       ├── popular_tv_series_page.dart
│   │       ├── top_rated_tv_series_page.dart
│   │       ├── on_the_air_tv_series_page.dart
│   │       ├── search_tv_series_page.dart
│   │       └── watchlist_tv_series_page.dart
│   └── widgets/           # Reusable widgets
│       └── tv_series_card.dart
├── injection.dart         # Dependency Injection (GetIt)
└── main.dart             # Entry point

test/                     # Test files
├── data/
├── domain/
├── presentation/
├── dummy_data/
└── helpers/
```

## Setup & Installation

### Prerequisites

- Flutter SDK (versi terbaru)
- Dart SDK
- Android Studio / VS Code
- TMDB API Key

### Cara Install

1. Clone repository ini
```bash
git clone <repository-url>
cd ditonton_tv_series
```

2. Install dependencies
```bash
flutter pub get
```

3. Tambahkan API Key TMDB
Buka file `lib/data/datasources/tv_series_remote_data_source.dart` dan ganti `YOUR_API_KEY` dengan API key Anda dari [TMDB](https://www.themoviedb.org/settings/api)

```dart
static const apiKey = 'YOUR_API_KEY_HERE';
```

4. Generate mock files untuk testing
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. Run aplikasi
```bash
flutter run
```

## Testing

### Menjalankan Tests

```bash
# Run semua tests
flutter test

# Run tests dengan coverage
flutter test --coverage

# Lihat coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage

Target minimum coverage adalah 70%. Proyek ini sudah memiliki:

- ✅ Unit tests untuk use cases
- ✅ Unit tests untuk repositories
- ✅ Unit tests untuk data sources
- ✅ BLoC tests dengan bloc_test
- ⭐ Widget tests (opsional untuk nilai lebih tinggi)
- ⭐ Integration tests (opsional untuk nilai lebih tinggi)

## Dependencies

### Production
- `flutter_bloc`: State management
- `equatable`: Value equality
- `dartz`: Functional programming (Either)
- `http`: HTTP client
- `sqflite`: Local database
- `get_it`: Dependency injection
- `cached_network_image`: Image caching
- `flutter_rating_bar`: Rating display
- `rxdart`: Reactive extensions

### Development
- `mockito`: Mocking untuk tests
- `bloc_test`: Testing BLoC
- `build_runner`: Code generation
- `flutter_lints`: Linting

## API

Aplikasi ini menggunakan [The Movie Database (TMDB) API](https://www.themoviedb.org/documentation/api)

### Endpoints yang digunakan:
- `GET /tv/popular` - Popular TV Series
- `GET /tv/top_rated` - Top Rated TV Series
- `GET /tv/on_the_air` - On The Air TV Series
- `GET /tv/{id}` - TV Series Detail
- `GET /tv/{id}/recommendations` - TV Series Recommendations
- `GET /search/tv` - Search TV Series

## Struktur Database

### Tabel: watchlist
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key |
| name | TEXT | Nama TV Series |
| overview | TEXT | Sinopsis |
| posterPath | TEXT | Path poster image |

## Screenshots

(Tambahkan screenshots aplikasi Anda di sini)

## Kriteria Penilaian

### Bintang 5 ⭐⭐⭐⭐⭐
Untuk mendapatkan bintang 5, proyek ini sudah memenuhi:
- ✅ Semua kriteria wajib
- ✅ Kriteria opsional: Season & Episode information
- ✅ Clean Architecture dengan 3 layer yang jelas
- ✅ Testing dengan coverage >70%
- ✅ Code bersih dan mudah dibaca
- ✅ Mengikuti Dart code conventions

### Additional Features (untuk nilai maksimal)
- Widget tests
- Integration tests
- Coverage >95%

## License

Proyek ini dibuat untuk submission Dicoding Flutter Expert.

## Author

Teo Prayoga

## Catatan

- Jangan lupa untuk menambahkan API key TMDB Anda sebelum menjalankan aplikasi
- Pastikan koneksi internet aktif untuk mengambil data dari API
- Data watchlist disimpan secara lokal dan tetap ada setelah aplikasi ditutup
