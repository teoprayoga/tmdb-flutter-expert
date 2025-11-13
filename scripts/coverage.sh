#!/bin/bash
# (Ini memberitahu terminal untuk menjalankan file sebagai script bash)

# Hentikan eksekusi jika ada perintah yang gagal
set -e

echo "1/3: Menjalankan tes dan mengumpulkan coverage..."
flutter test --coverage

echo "2/3: Membuat laporan HTML..."
# Menggunakan genhtml untuk mengonversi lcov.info ke HTML
genhtml coverage/lcov.info -o coverage/html

echo "3/3: Membuka laporan di browser..."

# PERINTAH 'open' SPESIFIK UNTUK macOS.
# Kita bisa membuatnya lebih pintar agar berfungsi di OS lain:
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open coverage/html/index.html
elif [[ "$OSTYPE" == "darwin"* ]]; then # macOS
    open coverage/html/index.html
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash, etc.)
    start coverage/html/index.html
else
    echo "Tidak bisa membuka browser secara otomatis."
    echo "Silakan buka file ini secara manual: coverage/html/index.html"
fi

echo "Selesai!"