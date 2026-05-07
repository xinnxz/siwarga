# Struktur Proyek - RT 05 Digital

## Root Directory
- `kode.gs`: Logika server-side utama (Google Apps Script). Berisi fungsi login, fetch data, dan manipulasi spreadsheet.
- `index.html`: File frontend tunggal. Berisi struktur HTML, styling (CSS), dan logika client-side (JS).
- `README.md`: Dokumentasi proyek (Manual penggunaan/instalasi).
- `CHANGELOG.md`: Catatan perubahan versi aplikasi.
- `.planning/`: (Baru) Folder untuk manajemen konteks GSD.
- `.agent/`: (Baru) Folder untuk skill asisten AI.

## Spreadsheet (Database)
Aplikasi terhubung dengan Google Sheets yang memiliki sheet-sheet berikut:
- `Akun`: Data kredensial pengguna (User, Pass, Nama, Peran, NoRumah).
- `JadwalRonda`: Jadwal petugas keamanan lingkungan.
- `Laporan`: Riwayat keluhan/laporan warga.
- `UangKematian`: Pencatatan kas dana sosial.
- `Kontrakan`: Status ketersediaan rumah kontrakan.
- `InfoRT`: Data pengumuman/berita RT.
- `Chat`: Riwayat forum diskusi warga.
