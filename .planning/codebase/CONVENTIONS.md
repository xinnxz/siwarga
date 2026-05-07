# Konvensi Koding - RT 05 Digital

## Penamaan (Naming Convention)
- **Functions**: Menggunakan `camelCase` (Contoh: `prosesLogin`, `updateStatusLaporan`).
- **Variables**: Menggunakan `camelCase` atau singkatan satu huruf untuk variabel lokal singkat (Contoh: `s` untuk Sheet, `d` untuk Data).
- **CSS Classes**: Menggunakan `kebab-case` (Contoh: `card-custom`, `btn-login`).
- **DOM IDs**: Menggunakan `camelCase` (Contoh: `inputUser`, `loginPage`).

## UI/UX Standards
- **Mobile First**: Desain dioptimalkan untuk perangkat mobile (viewport width).
- **Styling**: Menggunakan variabel CSS untuk konsistensi warna (Primary: `#1a237e`).
- **Feedback**: Menggunakan state `active` untuk navigasi bawah dan animasi `fadeIn` saat perpindahan halaman.

## Data Handling
- **Server Side**: Selalu menyertakan blok `try-catch` pada fungsi kritis untuk mencegah error aplikasi total.
- **Data Transfer**: Data dari Sheets dikirim sebagai Array of Arrays atau Object sederhana.
- **Date Formatting**: Tanggal dikonversi menjadi string di server menggunakan `Utilities.formatDate` sebelum dikirim ke client.
