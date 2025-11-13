# ⚡ Quick Start Guide

## 🎯 3 Langkah Cepat

### 1. Setup Project (5 menit)
```bash
cd ditonton_tv_series
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Tambah API Key (2 menit)
Buka: `lib/data/datasources/tv_series_remote_data_source.dart`

Ganti:
```dart
static const apiKey = 'YOUR_API_KEY';
```

Dengan API key dari: https://www.themoviedb.org/settings/api

### 3. Run App
```bash
flutter run
```

## ✅ Testing Coverage
```bash
flutter test --coverage
```
Target: 70%+ ✅

## 📦 Ready to Submit?

1. ✅ API key sudah diganti?
2. ✅ App berjalan tanpa error?
3. ✅ Tests passed?
4. ✅ Folder build dihapus?

```bash
# Hapus build folder
rm -rf build

# Create ZIP untuk submission
cd ..
zip -r ditonton_submission.zip ditonton_tv_series -x "*/build/*" "*/.dart_tool/*"
```

## 🎓 Kriteria Terpenuhi

✅ Daftar TV Series (Popular, Top Rated, On The Air)
✅ Detail TV Series dengan Season & Episode ⭐
✅ Pencarian dengan API
✅ Watchlist (SQLite - Persistent)
✅ Testing >70%
✅ Clean Architecture (3 layers)

Target: **Bintang 5** ⭐⭐⭐⭐⭐

## 📚 Dokumentasi Lengkap

- `README.md` - Project overview
- `SETUP_GUIDE.md` - Setup detail
- `PROJECT_SUMMARY.md` - Summary lengkap

## 🆘 Troubleshooting

### Error: API tidak return data
→ Cek API key dan koneksi internet

### Error: Mock files not found
→ Run: `flutter pub run build_runner build --delete-conflicting-outputs`

### Error: Tests failed
→ Pastikan mock files sudah di-generate

---

**Happy Coding!** 🚀

Jika ada pertanyaan, cek `SETUP_GUIDE.md` untuk dokumentasi lengkap.
