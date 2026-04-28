# 📱 SiWarga RT.05

> **Sistem Keamanan & Komunikasi Warga Digital**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-orange?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Private-red)]()

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

```bash
# 1. Clone repository
git clone https://github.com/[your-username]/siwarga.git
cd siwarga/siwarga_app

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase
flutterfire configure --project=siwarga-rt05

# 4. Run the app
flutter run
```

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
