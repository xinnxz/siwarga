# Changelog

All notable changes to the SiWarga project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Flutter app scaffold `siwarga_app/` (Riverpod, GoRouter, Firebase-ready)
- Design tokens & Stitch prompt templates (`docs/design/`)
- Sheet export helper `exportAllSheetsToJson()` in `kode.gs`
- Migration map `docs/MIGRATION-MAP.md`

### Changed
- README: dokumentasi dual-stack v1 (GAS) vs v2 (Flutter/Firebase)

---

## [1.0.0] — GAS Production Release

### Summary
Production deployment **RT 05 Digital** sebagai Google Web App: spreadsheet-backed CRUD, login sheet `Akun`, fitur pengumuman, laporan, SOS (WhatsApp), chat, warga, kontrakan, yatim, buku tamu, uang kematian, UMKM, jadwal ronda, Info RT.

### Details
- Backend: [`kode.gs`](kode.gs)
- Frontend: single-page [`index.html`](index.html) (Bootstrap 5, vanilla JS)

---

## [0.1.0] — TBD

### Planned (MVP)
- Authentication system (admin-only registration)
- Home screen with user profile and menu grid
- SOS Emergency button with push notifications
- Citizen reports (non-emergency)
- Discussion/chat
- Settings

---

## [0.2.0] — TBD

### Planned (Phase 2)
- RT announcements feed
- Kontrakan status tracking
- Guest book (buku tamu)
- Orphan data management

---

## [0.3.0] — TBD

### Planned (Phase 3)
- Financial management (iuran, infak)
- UMKM directory
- Admin dashboard
- Performance optimization
