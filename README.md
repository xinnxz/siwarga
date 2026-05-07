# 📱 SiWarga RT.05

> **Sistem Keamanan & Komunikasi Warga Digital**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-orange?logo=firebase)](https://firebase.google.com)
[![Google Apps Script](https://img.shields.io/badge/GAS-Legacy%20v1.0-yellow)](https://developers.google.com/apps-script)
[![License](https://img.shields.io/badge/License-Private-red)]()

---

## Status proyek

| Versi | Stack | Lokasi | Status |
|-------|--------|--------|--------|
| **v1.0** | Google Apps Script + Google Sheets + Web App (`index.html`) | repo root: [`kode.gs`](kode.gs), [`index.html`](index.html) | **Production** — dipakai RT saat ini |
| **v2.0** | Flutter + Firebase (Firestore, Auth, FCM, Storage) | [`siwarga_app/`](siwarga_app/) | **In progress** — migrasi sesuai `docs/architecture/` |

**Roadmap migrasi:** ekspor data Sheets (`exportAllSheetsToJson` di `kode.gs`), pemetaan kolom → Firestore ([`docs/MIGRATION-MAP.md`](docs/MIGRATION-MAP.md)), lalu cutover setelah parity fitur diuji Ketua RT.

---

## 🎯 Overview

SiWarga adalah aplikasi mobile untuk meningkatkan keamanan, komunikasi, dan efisiensi pengelolaan warga RT.05 / RW.05. Fitur utamanya meliputi:

- 🚨 **Tombol SOS Darurat** — Kirim alert ke seluruh warga dalam hitungan detik
- 📝 **Lapor Warga** — Dokumentasi masalah lingkungan (jalan rusak, lampu mati)
- 💬 **Diskusi Warga** — Komunikasi real-time antar warga
- 📢 **Info RT** — Pengumuman resmi dari Ketua RT
- 💰 **Keuangan** — Transparansi iuran & infak
- 🏪 **UMKM** — Direktori usaha warga lokal

---

## 🏗️ Architecture

- **Pattern**: Clean Architecture + Feature-First
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore, FCM, Storage)

📚 [Full Architecture Documentation](./docs/architecture/README.md)

---

## 📋 Prerequisites

| Tool | Version | Install Guide |
|------|---------|--------------|
| Flutter SDK | 3.x stable | [flutter.dev/install](https://flutter.dev/get-started/install) |
| Android Studio | Latest | [developer.android.com](https://developer.android.com/studio) |
| Firebase CLI | Latest | `npm install -g firebase-tools` |
| Git | Latest | [git-scm.com](https://git-scm.com) |

---

## 🚀 Getting Started

### A. Aplikasi produksi saat ini (v1 — Google Apps Script)

Spreadsheet + Script: [`kode.gs`](kode.gs), UI [`index.html`](index.html). Deploy sebagai Web App dari editor Apps Script.

Ekspor data untuk migrasi: jalankan fungsi `exportAllSheetsToJson()` di [`kode.gs`](kode.gs) (file JSON di Drive).

### B. Aplikasi mobile baru (v2 — Flutter, dalam repo)

```bash
cd siwarga_app
flutter create . --project-name siwarga_app   # jika folder platform belum ada
flutter pub get
flutterfire configure --project=<firebase_project_id>
flutter run
```

Detail setup: [`siwarga_app/README.md`](siwarga_app/README.md).

---

## 📂 Project Structure

```
lib/
├── core/           # Shared: theme, errors, utils, widgets
├── features/       # Feature modules (auth, emergency, reports...)
│   └── [feature]/
│       ├── domain/           # Entities, repo interfaces
│       ├── application/      # Providers, state management
│       ├── infrastructure/   # Firebase implementations
│       └── presentation/     # Screens, widgets
├── routing/        # App navigation (GoRouter)
└── services/       # Global services (FCM, storage)
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/unit/features/auth/
```

---

## 📦 Build

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔒 Security

- All data encrypted in transit (TLS) and at rest (AES-256)
- Role-based access control (warga / admin / super_admin)
- NIK masking in UI
- Firebase Security Rules enforced

---

## 📄 Documentation

| Document | Description |
|----------|-------------|
| [System Architecture](docs/architecture/01-system-architecture.md) | High-level design & tech stack |
| [Database Design](docs/architecture/02-database-design.md) | Schema & indexing strategy |
| [Security Architecture](docs/architecture/03-security-architecture.md) | Auth, RBAC, data protection |
| [API & Service Layer](docs/architecture/04-api-service-layer.md) | Service contracts & patterns |
| [Feature Specifications](docs/architecture/05-feature-specifications.md) | Detailed feature specs |
| [Project Structure](docs/architecture/06-project-structure.md) | Code organization & standards |

---

## 📜 License

Private — For RT.05 / RW.05 internal use only.

---

## 👥 Team

| Role | Name |
|------|------|
| Developer | [Your Name] |
| Product Owner | Ketua RT.05 |
