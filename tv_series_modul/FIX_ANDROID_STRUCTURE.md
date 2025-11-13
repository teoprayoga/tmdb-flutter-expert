# 🔧 Fix: AndroidManifest.xml Not Found

Maaf, ada file Android yang kurang. Ikuti langkah berikut untuk melengkapi struktur project:

## ✅ **Solusi Cepat (Recommended)**

Jalankan command ini di dalam folder project:

```bash
cd ditonton_tv_series

# Generate missing Android/iOS files
flutter create .
```

**PENTING:** Command ini akan:
- ✅ Generate semua file Android yang kurang
- ✅ Generate folder iOS (jika belum ada)
- ✅ **TIDAK** menghapus folder `lib/` dan `test/` yang sudah ada
- ✅ **TIDAK** menimpa file yang sudah ada

Setelah itu:

```bash
# Install dependencies
flutter pub get

# Generate mock files
flutter pub run build_runner build --delete-conflicting-outputs

# Run
flutter run
```

## 📋 **Step-by-Step Detail**

### 1. Pastikan di Folder Project

```bash
cd /Users/teo/Downloads/ditonton_tv_series
ls
```

Harusnya muncul:
```
lib/  test/  pubspec.yaml  README.md  android/  (dll)
```

### 2. Generate Missing Files

```bash
flutter create .
```

Output:
```
Creating project ditonton_tv_series...
  android/app/build.gradle (created)
  android/app/src/main/AndroidManifest.xml (created)
  android/gradlew (created)
  android/gradlew.bat (created)
  ...
Running "flutter pub get" in ditonton_tv_series...
```

### 3. Verify Android Files

```bash
ls android/
```

Harusnya muncul:
```
app/  build.gradle  gradle/  gradle.properties  
gradlew  gradlew.bat  settings.gradle
```

```bash
ls android/app/src/main/
```

Harusnya muncul:
```
AndroidManifest.xml  kotlin/  res/
```

### 4. Update Dependencies

```bash
flutter pub get
```

### 5. Setup API Key

Edit file: `lib/data/datasources/tv_series_remote_data_source.dart`

```dart
static const apiKey = 'YOUR_TMDB_API_KEY_HERE';
```

### 6. Generate Mocks

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Run!

```bash
flutter run
```

## 🔄 **Jika Masih Error**

### Error: "Gradle version too old"

```bash
# Di android/gradle/wrapper/gradle-wrapper.properties
# Ganti ke:
distributionUrl=https\://services.gradle.org/distributions/gradle-8.3-all.zip
```

### Error: "Android SDK not found"

```bash
# Check Flutter doctor
flutter doctor -v

# Install Android SDK via Android Studio:
# Tools → SDK Manager → Install SDK
```

### Error: "Kotlin version conflict"

Buka `android/build.gradle`, pastikan:
```gradle
ext.kotlin_version = '1.9.10'
```

### Error: "compileSdkVersion not found"

Buka `android/app/build.gradle`, pastikan ada:
```gradle
android {
    compileSdk 34  // atau 33
    ...
}
```

## 🎯 **Alternatif: Create Project Baru**

Jika `flutter create .` tidak berhasil, buat project baru dan copy files:

```bash
# 1. Buat project baru
flutter create ditonton_tv_series_new
cd ditonton_tv_series_new

# 2. Hapus lib/ dan test/ default
rm -rf lib/ test/

# 3. Copy lib/ dan test/ dari project lama
cp -r ../ditonton_tv_series/lib .
cp -r ../ditonton_tv_series/test .

# 4. Copy pubspec.yaml
cp ../ditonton_tv_series/pubspec.yaml .

# 5. Get dependencies
flutter pub get

# 6. Setup API key
# Edit lib/data/datasources/tv_series_remote_data_source.dart

# 7. Generate mocks
flutter pub run build_runner build --delete-conflicting-outputs

# 8. Run
flutter run
```

## ✅ **Checklist Setelah Fix**

- [ ] Folder `android/` ada dan lengkap
- [ ] File `android/app/src/main/AndroidManifest.xml` ada
- [ ] File `android/gradlew` ada (executable)
- [ ] `flutter doctor` tidak ada error critical
- [ ] `flutter devices` mendeteksi device
- [ ] API key sudah diganti
- [ ] `flutter pub get` berhasil
- [ ] Mock files sudah di-generate
- [ ] `flutter run` berhasil

## 📱 **Expected Result**

Setelah semua fix, saat run `flutter run`:

```
Launching lib/main.dart on SM G950F in debug mode...
Running Gradle task 'assembleDebug'...
✓ Built build/app/outputs/flutter-apk/app-debug.apk.
Installing build/app/outputs/flutter-apk/app.apk...
Synced 45.2MB.
```

App akan terbuka di device Android Anda! 🎉

## 🆘 **Butuh Bantuan?**

Jika masih error, kirim output dari:

```bash
flutter doctor -v
flutter run
```

Dan saya akan bantu troubleshoot lebih lanjut!
