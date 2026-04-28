# 🏗️ 01 — System Architecture

> **Version**: 1.0.0 | **Updated**: 2026-04-28

---

## 1. System Context (C4 Level 1)

```
              ┌──────────────┐
              │  Google Fonts │
              └──────┬───────┘
                     │
┌────────┐    ┌──────▼───────┐    ┌────────────┐
│ Warga  │◄──►│   SiWarga    │◄──►│  Firebase   │
│(Android)│   │  Flutter App │    │  Backend    │
└────────┘    └──────▲───────┘    └──────┬─────┘
                     │                   │
              ┌──────┴───────┐    ┌──────▼─────┐
              │  Admin (RT)  │    │    FCM      │
              │  (Android)   │    │  (Push)     │
              └──────────────┘    └────────────┘
```

---

## 2. Layered Architecture

| Layer | Responsibility | Dependencies |
|-------|---------------|--------------|
| **Presentation** | UI, Screens, Widgets, Navigation | Application Layer |
| **Application** | Providers (Riverpod), Use Cases, State Controllers | Domain Layer |
| **Domain** | Entities, Repository Interfaces, Value Objects | None (core) |
| **Infrastructure** | Firebase implementations, Local storage, Platform APIs | Domain Layer |

**Dependency Rule**: Dependencies point **inward**. Domain layer has **zero** external dependencies.

---

## 3. Technology Stack

### Frontend
| Tech | Version | Purpose |
|------|---------|---------|
| Flutter | 3.x stable | Cross-platform UI framework |
| Dart | 3.x | Programming language |
| Riverpod | 2.5+ | State management & DI |
| GoRouter | 14.x | Declarative routing |

### Backend (Firebase)
| Service | Purpose | Tier |
|---------|---------|------|
| Auth | Authentication & authorization | Free |
| Firestore | NoSQL document database | Free |
| FCM | Push notifications (SOS) | Free |
| Storage | Files & images | Free |
| Cloud Functions | Server logic (Phase 2) | Free |

### DevOps
| Tool | Purpose |
|------|---------|
| Git + GitHub | Version control |
| GitHub Actions | CI/CD (future) |
| Firebase CLI | Deployment |

---

## 4. Architecture Principles

### 4.1 Clean Architecture

```
  ┌─────────── PRESENTATION ───────────┐
  │   ┌─────── APPLICATION ─────────┐  │
  │   │   ┌───── DOMAIN ─────────┐  │  │
  │   │   │  ┌ INFRASTRUCTURE ┐  │  │  │
  │   │   │  └────────────────┘  │  │  │
  │   │   └──────────────────────┘  │  │
  │   └─────────────────────────────┘  │
  └────────────────────────────────────┘
```

### 4.2 SOLID Principles

| Principle | Application |
|-----------|-------------|
| **S**ingle Responsibility | One class = one job |
| **O**pen/Closed | Extend via interfaces |
| **L**iskov Substitution | Firebase ↔ Mock swappable |
| **I**nterface Segregation | Small, focused repo interfaces |
| **D**ependency Inversion | Domain depends on abstractions only |

### 4.3 Design Patterns

| Pattern | Usage | Why |
|---------|-------|-----|
| Repository | Data access | Abstract Firebase from domain |
| Observer | State mgmt | Riverpod reactive streams |
| Factory | Model creation | `fromFirestore()` constructors |
| Command | SOS system | Encapsulate emergency actions |

---

## 5. Data Flow

### Read Flow
```
Screen → Provider → Repository Interface → Firebase Impl → Firestore
                                                              │
Screen ← Provider (rebuilds) ← Stream update ◄───────────────┘
```

### Write Flow
```
User Action → Provider → Use Case (validate) → Repository → Firestore
                                                                │
UI auto-rebuilds ← Provider stream update ◄─────────────────────┘
```

### SOS Critical Path
```
Tap SOS → Select Category → Confirm
  │
  ├─► Write to Firestore (emergencies)
  ├─► Cloud Function → FCM HIGH PRIORITY → All Devices
  │     ├─► Foreground: Overlay + Siren sound
  │     └─► Background: System notification + Sound
  └─► Update local state (confirmation)
```

---

## 6. Offline-First Strategy

Firestore has built-in offline persistence:

| Mode | Behavior |
|------|----------|
| **Online** | Realtime sync with Firestore |
| **Offline** | Read from local cache, writes queued |
| **Reconnect** | Queued writes sync, cache updates |

---

## 7. Scalability Path

| Phase | Scale | Infrastructure |
|-------|-------|---------------|
| **Current** | 1 RT, ~100-300 users | Firebase Spark (Free) |
| **Growth** | Multi-RT, Kelurahan | Firebase Blaze, Cloud Functions |
| **Enterprise** | Multi-Kelurahan | Custom backend, microservices |

**Preparation**: All data namespaced with `rt_id` field for future multi-tenancy.

---

## 8. Performance Targets

| Metric | Target |
|--------|--------|
| App startup | < 3 seconds |
| SOS notification delivery | < 5 seconds |
| Firestore query | < 1 second |
| APK size | < 30 MB |
| Memory usage | < 150 MB |

---

## 9. Error Handling

```dart
sealed class AppResult<T> {
  const AppResult();
}
class Success<T> extends AppResult<T> {
  final T data;
  const Success(this.data);
}
class Failure<T> extends AppResult<T> {
  final AppError error;
  const Failure(this.error);
}
```

Error types: `network`, `auth`, `permission`, `notFound`, `validation`, `server`, `unknown`
