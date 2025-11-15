# Implementasi SSL Pinning

## Deskripsi
SSL Pinning telah diimplementasikan pada aplikasi TMDB Flutter untuk meningkatkan keamanan koneksi ke API The Movie DB. SSL Pinning memastikan bahwa aplikasi hanya menerima koneksi dari server yang memiliki sertifikat SSL yang tepat, mencegah serangan Man-in-the-Middle (MITM).

## Komponen yang Diimplementasikan

### 1. Sertifikat SSL
- **Lokasi**: `assets/certificates/themoviedb.pem`
- **Domain**: `*.themoviedb.org` dan `themoviedb.org`
- **Issuer**: Amazon RSA 2048 M04
- **Valid Until**: 2026-07-17

### 2. SSL Pinning Helper Class

#### File Utama
- `lib/common/ssl_pinning_helper.dart`
- `tv_series_modul/lib/common/ssl_pinning_helper.dart`

#### Fitur
- Memuat sertifikat dari assets menggunakan `rootBundle`
- Membuat `SecurityContext` dengan sertifikat trusted
- Mengkonfigurasi `HttpClient` dengan timeout 30 detik
- Validasi domain untuk memastikan hanya koneksi ke `*.themoviedb.org` yang diterima
- Fallback ke HTTP client biasa jika SSL pinning gagal

### 3. Dependency Injection Update

#### Main Module (`lib/injection.dart`)
- Fungsi `init()` diubah menjadi `Future<void> init()` untuk mendukung async
- HTTP Client dibuat menggunakan `SslPinningHelper.createSecureClient()`
- Client yang aman di-register ke dependency injection container

#### TV Series Module (`tv_series_modul/lib/injection.dart`)
- Fungsi `init()` diubah menjadi `Future<void> init()` untuk mendukung async
- HTTP Client dibuat menggunakan `SslPinningHelper.createSecureClient()`
- Client yang aman di-register ke dependency injection container

### 4. Main Application (`lib/main.dart`)
- Memanggil `await di.init()` untuk memastikan SSL pinning diinisialisasi sebelum aplikasi berjalan

## Cara Kerja SSL Pinning

1. **Saat Aplikasi Dimulai**:
   - `main.dart` memanggil `await di.init()`
   - Fungsi init memanggil `SslPinningHelper.createSecureClient()`

2. **Pembuatan Secure Client**:
   - Sertifikat PEM dimuat dari assets
   - `SecurityContext` dibuat dengan `withTrustedRoots: false` (hanya percaya sertifikat yang kita tentukan)
   - Sertifikat ditambahkan ke context menggunakan `setTrustedCertificatesBytes()`
   - `HttpClient` dibuat dengan SecurityContext tersebut

3. **Validasi Koneksi**:
   - Setiap request HTTP ke API akan divalidasi
   - Hanya koneksi ke `api.themoviedb.org` atau subdomain `*.themoviedb.org` yang diterima
   - Jika sertifikat tidak cocok, koneksi akan ditolak

4. **Fallback Mechanism**:
   - Jika terjadi error saat setup SSL pinning, aplikasi akan menggunakan HTTP client biasa
   - Error akan di-log untuk debugging

## Manfaat Keamanan

1. **Mencegah MITM Attack**: Aplikasi hanya akan terhubung ke server dengan sertifikat yang tepat
2. **Validasi Domain**: Hanya domain `*.themoviedb.org` yang diizinkan
3. **Certificate Validation**: Setiap koneksi divalidasi terhadap sertifikat yang di-pin

## Testing

Untuk memverifikasi SSL pinning berfungsi dengan baik:

1. **Build & Run Aplikasi**:
   ```bash
   flutter run
   ```

2. **Verifikasi Koneksi**:
   - Aplikasi harus dapat mengambil data dari API TMDB
   - Tidak ada error koneksi SSL

3. **Test MITM Protection** (Opsional):
   - Gunakan proxy seperti Charles atau Burp Suite
   - Coba intercept traffic TMDB
   - Aplikasi seharusnya menolak koneksi dengan proxy certificate

## Maintenance

### Update Sertifikat
Ketika sertifikat The Movie DB expired (Juli 2026), lakukan:

1. Download sertifikat baru dari The Movie DB
2. Replace file `assets/certificates/themoviedb.pem`
3. Rebuild aplikasi

### Troubleshooting

Jika aplikasi tidak dapat terhubung ke API:

1. Periksa log untuk error SSL pinning
2. Verifikasi sertifikat masih valid
3. Pastikan file `themoviedb.pem` ada di folder assets
4. Periksa bahwa assets didefinisikan di `pubspec.yaml`:
   ```yaml
   assets:
     - assets/certificates/
   ```

## Dependencies

Package yang digunakan:
- `http: ^1.2.2` - HTTP client dengan support IOClient
- `flutter/services.dart` - Untuk loading assets
- `dart:io` - Untuk SecurityContext dan HttpClient

## Struktur File

```
lib/
├── common/
│   └── ssl_pinning_helper.dart       # SSL Pinning helper untuk main module
├── injection.dart                     # DI dengan SSL client
└── main.dart                          # Inisialisasi SSL pinning

tv_series_modul/lib/
├── common/
│   └── ssl_pinning_helper.dart       # SSL Pinning helper untuk TV series module
└── injection.dart                     # DI dengan SSL client

assets/
└── certificates/
    └── themoviedb.pem                 # Sertifikat SSL The Movie DB
```

## Referensi
- [Flutter SSL Pinning Best Practices](https://flutter.dev/docs/development/data-and-backend/networking)
- [Dart IO Library - SecurityContext](https://api.dart.dev/stable/dart-io/SecurityContext-class.html)
- [OWASP Mobile Security - Network Communication](https://owasp.org/www-project-mobile-security/)
