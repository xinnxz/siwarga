# 📂 06 — Project Structure & Coding Standards

> **Version**: 1.0.0 | **Updated**: 2026-04-28

---

## 1. Project Structure (Feature-First + Clean Architecture)

```
siwarga_app/
│
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # MaterialApp + ProviderScope
│   │
│   ├── core/                              # SHARED / CORE MODULE
│   │   ├── constants/
│   │   │   ├── app_constants.dart         # RT name, app name, versions
│   │   │   ├── firestore_paths.dart       # Collection path constants
│   │   │   └── asset_paths.dart           # Asset file paths
│   │   │
│   │   ├── errors/
│   │   │   ├── app_error.dart             # AppError class
│   │   │   ├── app_result.dart            # Success/Failure sealed class
│   │   │   └── error_handler.dart         # Global error handler
│   │   │
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart    # BuildContext helpers
│   │   │   ├── string_extensions.dart     # String utilities
│   │   │   └── datetime_extensions.dart   # Date formatting
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # ThemeData configuration
│   │   │   ├── app_colors.dart            # Color palette
│   │   │   ├── app_typography.dart        # Text styles
│   │   │   └── app_dimensions.dart        # Spacing, radius, sizes
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.dart            # Form validators
│   │   │   ├── formatters.dart            # NIK masking, phone format
│   │   │   └── logger.dart                # App logger
│   │   │
│   │   └── widgets/                       # SHARED WIDGETS
│   │       ├── app_button.dart            # Primary/secondary buttons
│   │       ├── app_text_field.dart         # Styled text input
│   │       ├── app_card.dart              # Styled card
│   │       ├── app_dialog.dart            # Confirmation dialogs
│   │       ├── loading_overlay.dart       # Loading indicator
│   │       ├── empty_state.dart           # Empty list placeholder
│   │       ├── error_widget.dart          # Error display
│   │       └── user_avatar.dart           # Profile picture widget
│   │
│   ├── features/                          # FEATURE MODULES
│   │   │
│   │   ├── auth/                          # ── AUTH FEATURE ──
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_entity.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository.dart     # Abstract
│   │   │   ├── application/
│   │   │   │   ├── auth_provider.dart
│   │   │   │   └── auth_state.dart
│   │   │   ├── infrastructure/
│   │   │   │   └── firebase_auth_repository.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   └── register_screen.dart     # Admin only
│   │   │       └── widgets/
│   │   │           └── login_form.dart
│   │   │
│   │   ├── home/                          # ── HOME/BERANDA ──
│   │   │   ├── domain/
│   │   │   │   └── entities/
│   │   │   ├── application/
│   │   │   │   └── home_provider.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── home_screen.dart
│   │   │       └── widgets/
│   │   │           ├── profile_header.dart
│   │   │           ├── menu_grid.dart
│   │   │           ├── announcement_feed.dart
│   │   │           └── citizen_list.dart
│   │   │
│   │   ├── emergency/                     # ── SOS DARURAT ──
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── emergency_entity.dart
│   │   │   │   └── repositories/
│   │   │   │       └── emergency_repository.dart
│   │   │   ├── application/
│   │   │   │   ├── emergency_provider.dart
│   │   │   │   └── emergency_state.dart
│   │   │   ├── infrastructure/
│   │   │   │   ├── firebase_emergency_repository.dart
│   │   │   │   └── siren_service.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── sos_screen.dart
│   │   │       │   └── emergency_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── sos_button.dart
│   │   │           ├── category_selector.dart
│   │   │           ├── confirm_dialog.dart
│   │   │           └── active_emergency_card.dart
│   │   │
│   │   ├── reports/                       # ── LAPOR WARGA ──
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── report_entity.dart
│   │   │   │   └── repositories/
│   │   │   │       └── report_repository.dart
│   │   │   ├── application/
│   │   │   │   └── report_provider.dart
│   │   │   ├── infrastructure/
│   │   │   │   └── firebase_report_repository.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── report_list_screen.dart
│   │   │       │   ├── create_report_screen.dart
│   │   │       │   └── report_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── report_card.dart
│   │   │           └── status_badge.dart
│   │   │
│   │   ├── discussion/                    # ── DISKUSI WARGA ──
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── message_entity.dart
│   │   │   │   └── repositories/
│   │   │   │       └── discussion_repository.dart
│   │   │   ├── application/
│   │   │   │   └── discussion_provider.dart
│   │   │   ├── infrastructure/
│   │   │   │   └── firebase_discussion_repository.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── discussion_screen.dart
│   │   │       └── widgets/
│   │   │           ├── message_bubble.dart
│   │   │           ├── message_input.dart
│   │   │           └── system_message.dart
│   │   │
│   │   ├── settings/                      # ── PENGATURAN ──
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── settings_screen.dart
│   │   │       │   ├── edit_profile_screen.dart
│   │   │       │   └── change_password_screen.dart
│   │   │       └── widgets/
│   │   │           └── settings_tile.dart
│   │   │
│   │   ├── announcements/                 # ── PENGUMUMAN RT ──
│   │   │   ├── domain/
│   │   │   ├── application/
│   │   │   ├── infrastructure/
│   │   │   └── presentation/
│   │   │
│   │   ├── kontrakan/                     # ── DATA KONTRAKAN ──
│   │   │   ├── domain/
│   │   │   ├── application/
│   │   │   ├── infrastructure/
│   │   │   └── presentation/
│   │   │
│   │   ├── keuangan/                      # ── KEUANGAN ──
│   │   │   ├── domain/
│   │   │   ├── application/
│   │   │   ├── infrastructure/
│   │   │   └── presentation/
│   │   │
│   │   ├── umkm/                          # ── UMKM WARGA ──
│   │   │   ├── domain/
│   │   │   ├── application/
│   │   │   ├── infrastructure/
│   │   │   └── presentation/
│   │   │
│   │   ├── buku_tamu/                     # ── BUKU TAMU ──
│   │   │   ├── domain/
│   │   │   ├── application/
│   │   │   ├── infrastructure/
│   │   │   └── presentation/
│   │   │
│   │   └── anak_yatim/                    # ── DATA ANAK YATIM ──
│   │       ├── domain/
│   │       ├── application/
│   │       ├── infrastructure/
│   │       └── presentation/
│   │
│   ├── routing/                           # APP ROUTING
│   │   ├── app_router.dart                # GoRouter configuration
│   │   ├── route_names.dart               # Named route constants
│   │   └── route_guards.dart              # Auth & role guards
│   │
│   └── services/                          # GLOBAL SERVICES
│       ├── notification_service.dart       # FCM + Local notifications
│       ├── storage_service.dart            # Firebase Storage uploads
│       └── connectivity_service.dart       # Online/offline detection
│
├── assets/
│   ├── images/
│   │   ├── logo.png                       # App logo
│   │   ├── logo_dark.png                  # Logo for dark theme
│   │   └── empty_state.png               # Empty list illustration
│   ├── icons/
│   │   └── app_icon.png                   # Launcher icon
│   └── sounds/
│       └── siren.mp3                      # Emergency siren sound
│
├── test/                                  # TESTS
│   ├── unit/
│   │   ├── core/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── emergency/
│   │   │   └── reports/
│   │   └── services/
│   ├── widget/
│   │   ├── features/
│   │   └── core/
│   └── integration/
│       └── auth_flow_test.dart
│
├── android/                               # Android config
├── ios/                                   # iOS config (future)
├── docs/                                  # Documentation
│   └── architecture/                      # This documentation
│
├── pubspec.yaml                           # Dependencies
├── analysis_options.yaml                  # Lint rules
├── .gitignore
├── README.md
└── firebase.json
```

---

## 2. Coding Standards

### 2.1 Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Files | `snake_case` | `user_entity.dart` |
| Classes | `PascalCase` | `UserEntity` |
| Variables | `camelCase` | `userName` |
| Constants | `camelCase` or `SCREAMING_SNAKE` | `maxRetries`, `API_KEY` |
| Private | `_prefixed` | `_isLoading` |
| Providers | `camelCase` + `Provider` suffix | `authStateProvider` |
| Enums | `PascalCase` values | `UserRole.admin` |

### 2.2 File Organization

Every Dart file follows this order:
```dart
// 1. Dart imports
import 'dart:async';

// 2. Package imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 3. Project imports (relative)
import '../../core/errors/app_result.dart';

// 4. Part directives (if using code generation)
part 'user_entity.g.dart';

// 5. Constants (if any)
const int _maxRetries = 3;

// 6. Class definition
class UserEntity {
  // Fields (final first, then mutable)
  final String uid;
  final String nama;
  
  // Constructor
  const UserEntity({
    required this.uid,
    required this.nama,
  });
  
  // Factory constructors
  factory UserEntity.fromFirestore(DocumentSnapshot doc) { ... }
  
  // Methods
  Map<String, dynamic> toFirestore() { ... }
  
  // toString, ==, hashCode
  @override
  String toString() => 'UserEntity(uid: $uid, nama: $nama)';
}
```

### 2.3 Widget Guidelines

```dart
/// GOOD: Stateless where possible
class ReportCard extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback? onTap;
  
  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    // Use theme from context
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    
    return Card(
      child: ListTile(
        title: Text(report.judul, style: theme.textTheme.titleMedium),
        subtitle: Text(report.namaPelapor),
        trailing: StatusBadge(status: report.status),
        onTap: onTap,
      ),
    );
  }
}
```

### 2.4 Provider Guidelines

```dart
/// PATTERN: Provider per feature, keep providers small
/// 
/// Provider types:
/// - Provider         → Singleton services, repositories
/// - StateProvider     → Simple mutable state
/// - FutureProvider    → One-time async data
/// - StreamProvider    → Realtime data streams
/// - NotifierProvider  → Complex state with methods

// Repository provider (singleton)
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return FirebaseReportRepository(FirebaseFirestore.instance);
});

// Stream provider (realtime list)
final reportsProvider = StreamProvider.autoDispose<List<ReportEntity>>((ref) {
  final repo = ref.watch(reportRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return repo.watchReports(user.rtId);
});

// Notifier for complex state
class ReportNotifier extends AsyncNotifier<List<ReportEntity>> {
  @override
  Future<List<ReportEntity>> build() async {
    // Initial load
  }
  
  Future<void> createReport(...) async {
    // Create and refresh
  }
}
```

---

## 3. Git Conventions

### 3.1 Branch Strategy

```
main                    ← Production ready
├── develop             ← Integration branch
│   ├── feature/auth-login
│   ├── feature/sos-button
│   ├── feature/discussion-chat
│   ├── fix/login-crash
│   └── chore/update-deps
```

### 3.2 Commit Messages

Format: `type(scope): description`

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting (no logic change) |
| `refactor` | Code restructure |
| `test` | Adding tests |
| `chore` | Build/tooling |

Examples:
```
feat(auth): implement login screen with Firebase Auth
fix(sos): resolve siren not playing on Android 13+
docs(arch): add database design documentation
refactor(reports): extract report card to separate widget
test(auth): add unit tests for login validation
chore(deps): bump firebase_core to 3.1.0
```

---

## 4. Testing Strategy

### 4.1 Test Pyramid

```
        ┌─────────┐
        │  E2E /  │   Few (critical flows)
        │ Integr. │   Login → SOS → Verify
        ├─────────┤
        │ Widget  │   Some (key UI components)
        │  Tests  │   SOS button, Report card
        ├─────────┤
        │  Unit   │   Many (business logic)
        │  Tests  │   Validators, formatters, services
        └─────────┘
```

### 4.2 Test Coverage Targets

| Layer | Target | Focus |
|-------|--------|-------|
| Domain (entities, validators) | 90%+ | Business rules |
| Application (providers) | 80%+ | State management |
| Infrastructure (repos) | 70%+ | Firebase interactions |
| Presentation (widgets) | 60%+ | Key UI components |

### 4.3 Test File Naming

```
Source:  lib/features/auth/domain/entities/user_entity.dart
Test:    test/unit/features/auth/domain/entities/user_entity_test.dart
```

---

## 5. Environment Configuration

### 5.1 Flavor / Environment Setup

| Env | Firebase Project | Purpose |
|-----|-----------------|---------|
| `dev` | siwarga-rt05-dev | Development & testing |
| `prod` | siwarga-rt05 | Production |

### 5.2 Environment Variables

```dart
// core/config/app_config.dart
enum Environment { dev, prod }

class AppConfig {
  static late Environment environment;
  
  static String get appName {
    switch (environment) {
      case Environment.dev: return 'SiWarga DEV';
      case Environment.prod: return 'SiWarga RT.05';
    }
  }
  
  static bool get isDebug => environment == Environment.dev;
}
```

---

## 6. CI/CD Pipeline (Future)

```
┌─────────────────────────────────────────┐
│           GitHub Actions CI/CD           │
│                                          │
│  On Push to develop:                     │
│  ┌──────┐ ┌──────┐ ┌────────┐          │
│  │ Lint │→│ Test │→│ Build  │          │
│  │      │ │      │ │  APK   │          │
│  └──────┘ └──────┘ └────────┘          │
│                                          │
│  On Push to main:                        │
│  ┌──────┐ ┌──────┐ ┌────────┐ ┌──────┐ │
│  │ Lint │→│ Test │→│ Build  │→│Deploy│ │
│  │      │ │      │ │Release │ │ APK  │ │
│  └──────┘ └──────┘ └────────┘ └──────┘ │
└─────────────────────────────────────────┘
```
