# Migrasi data Sheets → Firestore

1. Jalankan `exportAllSheetsToJson()` di Google Apps Script (lihat root repo `kode.gs`).
2. Unduh file `siwarga_export_*.json` dari Google Drive ke folder ini sebagai `siwarga_export.json`.
3. Gunakan salah satu metode:

### A. Skrip Node (disarankan untuk batch besar)

```bash
cd tool
npm init -y
npm install firebase-admin
```

Salin service account JSON dari Firebase Console → Project settings → Service accounts, simpan sebagai `service-account.json` (**jangan commit**).

Edit dan jalankan `import_firestore_example.js` (rename sesuai kebutuhan).

### B. Firebase CLI

Untuk bundle kecil, bisa gunakan manual import atau tulis koleksi lewat konsol Firebase.

### Cutover GAS

Setelah semua warga dipastikan bisa login di app Flutter dan data sudah diverifikasi Ketua RT:

- Nonaktifkan deploy Web App lama atau kosongkan trigger tulis di spreadsheet (mode **readonly**).
- Dokumentasi freeze: lihat komentar di `kode.gs` pada repo root.
