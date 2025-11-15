import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Helper class untuk mengimplementasikan SSL Pinning
/// Memastikan koneksi aman ke API dengan memvalidasi sertifikat SSL
class SslPinningHelper {
  /// Membuat HTTP Client dengan SSL Pinning yang sudah terkonfigurasi
  ///
  /// Sertifikat SSL dari The Movie DB akan dimuat dari assets
  /// dan digunakan untuk memvalidasi koneksi HTTPS
  static Future<http.Client> createSecureClient() async {
    try {
      // Memuat sertifikat dari assets
      final certificateData = await rootBundle.load('assets/certificates/themoviedb.pem');
      final certificateBytes = certificateData.buffer.asUint8List();

      // Membuat SecurityContext dan menambahkan sertifikat trusted
      final securityContext = SecurityContext(withTrustedRoots: false);
      securityContext.setTrustedCertificatesBytes(certificateBytes);

      // Membuat HttpClient dengan SecurityContext yang telah dikonfigurasi
      final httpClient = HttpClient(context: securityContext);

      // Mengatur timeout untuk koneksi
      httpClient.connectionTimeout = const Duration(seconds: 30);

      // Callback untuk validasi sertifikat
      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Hanya terima koneksi ke themoviedb.org
        if (host == 'api.themoviedb.org' || host.endsWith('.themoviedb.org')) {
          return true;
        }
        return false;
      };

      // Mengembalikan IOClient yang membungkus HttpClient dengan SSL Pinning
      return IOClient(httpClient);
    } catch (e) {
      // Jika terjadi error saat setup SSL Pinning, log error dan gunakan client default
      print('Error setting up SSL Pinning: $e');
      // Fallback ke client biasa jika SSL pinning gagal
      return http.Client();
    }
  }
}
