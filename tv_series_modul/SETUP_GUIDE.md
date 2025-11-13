# Setup Guide - Ditonton TV Series

Panduan lengkap untuk setup dan menjalankan aplikasi Ditonton TV Series.

## Langkah 1: Prerequisites

Pastikan Anda sudah menginstall:

1. **Flutter SDK** (versi terbaru)
   ```bash
   flutter --version
   ```
   Jika belum terinstall, download dari: https://flutter.dev/docs/get-started/install

2. **Dart SDK** (biasanya sudah include dengan Flutter)

3. **IDE** (pilih salah satu):
   - Android Studio + Flutter Plugin
   - VS Code + Flutter Extension
   - IntelliJ IDEA + Flutter Plugin

4. **Emulator/Device**:
   - Android Emulator / iOS Simulator
   - Atau physical device

## Langkah 2: Clone & Install Dependencies

```bash
# Clone repository (jika dari Git)
git clone <repository-url>
cd ditonton_tv_series

# Atau jika dari ZIP, extract dulu

# Install dependencies
flutter pub get
```

## Langkah 3: Setup TMDB API Key

1. Daftar di [TMDB](https://www.themoviedb.org/)
2. Buat API Key di https://www.themoviedb.org/settings/api
3. Copy API Key Anda
4. Buka file `lib/data/datasources/tv_series_remote_data_source.dart`
5. Ganti `YOUR_API_KEY` dengan API key Anda:

```dart
static const apiKey = 'PASTE_YOUR_API_KEY_HERE';
```

**PENTING**: Jangan commit API key ke repository public!

## Langkah 4: Generate Mock Files untuk Testing

```bash
# Generate mock files
flutter pub run build_runner build --delete-conflicting-outputs

# Tunggu hingga selesai
# File .mocks.dart akan otomatis di-generate
```

## Langkah 5: Run Tests (Opsional tapi Disarankan)

```bash
# Run semua tests
flutter test

# Run dengan coverage report
flutter test --coverage

# Lihat coverage dalam format HTML (macOS/Linux)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Untuk Windows, install genhtml terlebih dahulu atau gunakan:
# https://github.com/linux-test-project/lcov
```

Target coverage: **70%+** ✅

## Langkah 6: Run Aplikasi

```bash
# Check connected devices
flutter devices

# Run di device/emulator
flutter run

# Atau pilih specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

## Troubleshooting

### Error: "No usable version of the SDK can be found"

```bash
flutter doctor
flutter upgrade
```

### Error: "CocoaPods not installed" (iOS)

```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### Error: "Gradle build failed" (Android)

1. Clean project:
```bash
flutter clean
flutter pub get
```

2. Check Android Studio SDK settings

### Error: "Mock files not found"

```bash
# Re-generate mocks
flutter pub run build_runner build --delete-conflicting-outputs
```

### API tidak mengembalikan data

1. Pastikan API key sudah benar
2. Check koneksi internet
3. Coba test API key di browser:
   ```
   https://api.themoviedb.org/3/tv/popular?api_key=YOUR_API_KEY
   ```

## Tips Development

### Hot Reload
Tekan `r` di terminal saat app running untuk hot reload

### Hot Restart
Tekan `R` di terminal untuk hot restart

### Debug Mode
```bash
flutter run --debug
```

### Check Code Quality
```bash
# Run analyzer
flutter analyze

# Format code
flutter format lib test
```

## Struktur Testing

```bash
test/
├── data/
│   ├── models/              # Test models
│   └── repositories/        # Test repositories
├── domain/
│   └── usecases/           # Test use cases
├── presentation/
│   ├── bloc/               # Test blocs
│   └── widgets/            # Widget tests
├── dummy_data/             # Test data
└── helpers/                # Test helpers & mocks
```

## Build Release APK

```bash
# Build APK
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk

# Build App Bundle (untuk Play Store)
flutter build appbundle --release
```

## Submission Checklist

Sebelum submit, pastikan:

- [ ] Semua kriteria wajib terpenuhi
- [ ] API key sudah diganti dengan yang valid
- [ ] Tests berjalan dengan baik
- [ ] Coverage >= 70%
- [ ] Aplikasi berjalan tanpa error
- [ ] Folder `build` sudah dihapus sebelum zip
- [ ] Size ZIP < 25MB

### Menghapus folder build sebelum zip:

```bash
# Hapus build folder
rm -rf build

# Atau di Windows:
# rmdir /s build

# Zip project
zip -r ditonton_tv_series.zip ditonton_tv_series -x "*/build/*" "*/.dart_tool/*"
```

## Kontak & Support

Jika ada pertanyaan, silakan:
1. Check dokumentasi Flutter: https://flutter.dev/docs
2. Check dokumentasi TMDB API: https://developers.themoviedb.org/3
3. Search di Stack Overflow

## Catatan Penting

1. **Jangan** commit API key ke public repository
2. **Jangan** lupa menjalankan `flutter pub get` setelah clone
3. **Jangan** lupa generate mock files sebelum run tests
4. **Hapus** folder build sebelum create ZIP untuk submission

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [TMDB API Documentation](https://developers.themoviedb.org/3)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

Selamat coding! 🚀
