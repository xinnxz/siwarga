# SiWarga App (Flutter)

## Setup pertama kali

1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install/windows) dan pastikan `flutter` ada di PATH.
2. Di folder ini, generate folder platform (Android/iOS/Web) jika belum ada:

```bash
cd siwarga_app
flutter create . --project-name siwarga_app
```

3. Firebase — login dan konfigurasi:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

Ini menghasilkan `lib/firebase_options.dart`. Tanpa langkah ini, ganti stub dengan file yang di-generate.

4. Dependencies:

```bash
flutter pub get
```

5. Jalankan:

```bash
flutter run
```

## Migrasi data Sheets

1. Di Google Apps Script, jalankan `exportAllSheetsToJson()` — file JSON muncul di Google Drive.
2. Unduh JSON ke `tool/siwarga_export.json`.
3. Ikuti [`tool/README.md`](tool/README.md) untuk import ke Firestore (service account).

## Struktur

Clean architecture per fitur di `lib/features/*` — lihat `docs/architecture/06-project-structure.md` di repo root.
