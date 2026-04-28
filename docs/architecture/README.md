# 📚 SiWarga — Architecture Documentation

> **Version**: 1.0.0  
> **Last Updated**: 2026-04-28  
> **Status**: Draft → Review → Approved  
> **Author**: SiWarga Engineering Team

---

## 📁 Documentation Index

| # | Document | Description | Status |
|---|----------|-------------|--------|
| 1 | [System Architecture](./01-system-architecture.md) | High-level system design, C4 diagrams, tech stack | ✅ Complete |
| 2 | [Database Design](./02-database-design.md) | ERD, collection schemas, indexing strategy | ✅ Complete |
| 3 | [Security Architecture](./03-security-architecture.md) | Auth flow, RBAC, data protection, threat model | ✅ Complete |
| 4 | [API & Service Layer](./04-api-service-layer.md) | Service contracts, data flow, error handling | ✅ Complete |
| 5 | [Feature Specifications](./05-feature-specifications.md) | Detailed specs per feature with acceptance criteria | ✅ Complete |
| 6 | [Project Structure](./06-project-structure.md) | Clean Architecture, folder conventions, coding standards | ✅ Complete |

---

## 🎯 Quick Links

- **Tech Stack**: Flutter + Firebase (Firestore, Auth, FCM, Storage)
- **Architecture Pattern**: Clean Architecture + Feature-First
- **State Management**: Riverpod
- **Target Platform**: Android (APK) → iOS (future)

---

## 🏗️ Architecture Decision Records (ADR)

| ADR | Decision | Rationale |
|-----|----------|-----------|
| ADR-001 | Flutter over React Native | Better performance, single codebase, Google ecosystem synergy with Firebase |
| ADR-002 | Firebase over custom backend | Zero server management, built-in auth/realtime/push, free tier sufficient for RT scale |
| ADR-003 | Firestore over Realtime DB | Better querying, offline support, scalable document model |
| ADR-004 | Riverpod over Bloc | Simpler API, compile-safe, better testability, no boilerplate |
| ADR-005 | Feature-first folder structure | Better scalability, each feature is self-contained module |
| ADR-006 | Email auth over phone OTP | Zero cost, unlimited users, no SMS provider dependency |
| ADR-007 | FCM high-priority for SOS | Ensures notification delivery even in Doze mode |
