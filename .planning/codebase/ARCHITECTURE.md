# Arsitektur Aplikasi - RT 05 Digital

## Pola Komunikasi (Client-Server)
Aplikasi menggunakan pola asinkron standar Google Apps Script:
1. **Request**: Client memanggil fungsi server menggunakan `google.script.run`.
2. **Execution**: Server (`kode.gs`) berinteraksi dengan Google Sheets.
3. **Response**: Server mengembalikan data (objek/array) ke client melalui `withSuccessHandler`.

## Alur Utama
- **Entry Point**: Fungsi `doGet()` di `kode.gs` mengevaluasi `index.html` sebagai template.
- **Manajemen State**:
  - Client menyimpan sesi pengguna di `localStorage` (`rt05_session`).
  - Halaman-halaman (`page`) di frontend dikelola sebagai SPA sederhana dengan menyembunyikan/menampilkan elemen DOM berdasarkan ID.
- **Database CRUD**:
  - Fungsi universal `fetchData` dan `saveData` digunakan untuk meminimalkan pengulangan kode.
  - Manipulasi data langsung menggunakan `appendRow`, `getRange().setValues()`, dan `deleteRow`.
