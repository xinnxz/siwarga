# Hal-hal yang Perlu Diperhatikan (Concerns) - RT 05 Digital

## Teknis (GAS)
- **Quotas**: Batas eksekusi harian GAS dan limitasi Spreadsheet (5 juta sel).
- **Concurrency**: Potensi tabrakan data jika banyak warga menyimpan data secara bersamaan (disarankan menggunakan `LockService` di masa depan).

## Keamanan
- **Plaintext Password**: Saat ini password disimpan dalam bentuk teks biasa di Sheet `Akun`.
- **Client-Side Storage**: Sesi disimpan di `localStorage` tanpa enkripsi tambahan.

## Maintenance
- **Single File UI**: `index.html` sudah mencapai >1400 baris. Di masa depan disarankan untuk memisahkan CSS dan JS menggunakan `HtmlService.createHtmlOutputFromFile`.
