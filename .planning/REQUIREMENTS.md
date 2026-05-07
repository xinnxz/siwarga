# Requirements: SiWarga v2.0

**Defined:** 2026-05-08
**Core Value:** Memberikan akses komunikasi dan koordinasi darurat yang instan dan reliable bagi seluruh warga dalam satu komunitas residensial.

## v2.0 Requirements

### Infrastructure & Architecture

- [ ] **INFRA-01**: Next.js project initialized dengan App Router + TypeScript
- [ ] **INFRA-02**: Prisma ORM configured dengan Supabase PostgreSQL connection
- [ ] **INFRA-03**: Database schema designed dan migrated via Prisma
- [ ] **INFRA-04**: Supabase project created (Auth, Database, Storage, Realtime)
- [ ] **INFRA-05**: Environment variables configured (.env.local)
- [ ] **INFRA-06**: Vercel deployment pipeline established (auto-deploy from main)
- [ ] **INFRA-07**: ESLint + Prettier configured dengan rules standar

### Authentication & Authorization

- [ ] **AUTH-01**: Supabase Auth integration — signup, login, logout, session
- [ ] **AUTH-02**: Registration flow: Invite Code → Nama → No Rumah → Password
- [ ] **AUTH-03**: Invite code validated against `invite_codes` table
- [ ] **AUTH-04**: No Rumah validated against `residents` table
- [ ] **AUTH-05**: Role-based access: `admin` (Ketua/Pengurus) vs `warga`
- [ ] **AUTH-06**: Admin panel: generate invite codes, set expiry, max usage
- [ ] **AUTH-07**: Admin dapat nonaktifkan/hapus akun warga
- [ ] **AUTH-08**: Protected API routes dengan middleware auth check
- [ ] **AUTH-09**: Session persistence across browser refresh (Supabase session)

### Design System & UI

- [ ] **UI-01**: CSS design system — custom properties, color palette, typography
- [ ] **UI-02**: Glassmorphism component library (card, button, input, nav, badge, modal)
- [ ] **UI-03**: Micro-animations: page transitions, hover effects, loading states
- [ ] **UI-04**: Mobile-first responsive layout (360px → 1920px breakpoints)
- [ ] **UI-05**: Bottom navigation dengan animated active indicator
- [ ] **UI-06**: Dark mode + Light mode — keduanya premium quality
- [ ] **UI-07**: Empty states dengan ilustrasi/icon
- [ ] **UI-08**: Loading skeletons saat data fetching
- [ ] **UI-09**: Login + Register page dengan branding premium

### SOS Emergency System

- [ ] **SOS-01**: Tombol SOS besar dengan pulse animation
- [ ] **SOS-02**: 4 kategori darurat: Maling, Kebakaran, Medis, Lainnya
- [ ] **SOS-03**: Konfirmasi dialog 2 langkah sebelum broadcast
- [ ] **SOS-04**: SOS broadcast via Supabase Realtime ke semua admin
- [ ] **SOS-05**: SOS log tersimpan di database (timestamp, user, kategori, status)
- [ ] **SOS-06**: Riwayat SOS viewable oleh admin
- [ ] **SOS-07**: WhatsApp fallback tetap tersedia sebagai backup

### Real-time Chat

- [ ] **CHAT-01**: Real-time messaging via Supabase Realtime subscriptions
- [ ] **CHAT-02**: Chat bubble UI (mine/other) dengan timestamp
- [ ] **CHAT-03**: Scroll-to-bottom button untuk pesan baru
- [ ] **CHAT-04**: Online presence indicator (opsional)

### Reporting System

- [ ] **RPT-01**: Form laporan warga (text based)
- [ ] **RPT-02**: Status lifecycle: Pending → Diproses → Selesai / Ditolak
- [ ] **RPT-03**: Visual status badges dengan icon + warna
- [ ] **RPT-04**: Admin response/komentar pada laporan

### Dashboard

- [ ] **DASH-01**: Welcome header dengan user info + branding
- [ ] **DASH-02**: Stats widgets: jumlah warga, laporan aktif, SOS bulan ini
- [ ] **DASH-03**: Quick action buttons (SOS, Lapor, Chat)
- [ ] **DASH-04**: Pengumuman feed (latest 5)
- [ ] **DASH-05**: Menu grid navigasi ke semua modul

### Data Management (CRUD)

- [ ] **DATA-01**: Warga management (nama, no rumah, no HP, status)
- [ ] **DATA-02**: Pengumuman CRUD dengan admin-only create
- [ ] **DATA-03**: Kas keuangan (uang kematian) dengan saldo otomatis
- [ ] **DATA-04**: Buku tamu CRUD
- [ ] **DATA-05**: UMKM warga directory
- [ ] **DATA-06**: Data anak yatim
- [ ] **DATA-07**: Kontrakan status tracking
- [ ] **DATA-08**: Jadwal ronda management
- [ ] **DATA-09**: Info RT dengan image upload (Supabase Storage)

### PWA Features

- [ ] **PWA-01**: manifest.json — icons, theme, splash screen
- [ ] **PWA-02**: Service worker — static asset caching
- [ ] **PWA-03**: Installable via "Add to Home Screen"
- [ ] **PWA-04**: Offline fallback page
- [ ] **PWA-05**: App-like experience (no browser chrome)

### Security

- [ ] **SEC-01**: All passwords hashed via Supabase Auth (bcrypt)
- [ ] **SEC-02**: Row-Level Security (RLS) policies on all tables
- [ ] **SEC-03**: Input sanitization pada semua form
- [ ] **SEC-04**: CSRF protection via Next.js defaults
- [ ] **SEC-05**: Rate limiting pada API routes kritis (login, SOS)

## v3.0 Requirements (Deferred)

- **NOTF-01**: Web Push notifications untuk SOS dan pengumuman
- **NOTF-02**: Badge count di PWA icon
- **ADV-01**: Upload foto di laporan warga
- **ADV-02**: Profil warga dengan avatar upload
- **ADV-03**: Export PDF (laporan keuangan)
- **ADV-04**: Multi-RT/RW support (tenant isolation)
- **ADV-05**: Admin analytics dashboard (charts, trends)
- **ADV-06**: Iuran + pembayaran tracking
- **ADV-07**: Voting/polling system

## Out of Scope

| Feature | Reason |
|---------|--------|
| Flutter/React Native | PWA cukup untuk skala ini |
| Google Sheets backend | Digantikan PostgreSQL sepenuhnya |
| Payment gateway | Kas manual sesuai konteks RT |
| Video call | Bukan scope manajemen komunitas |
| AI features | Fokus core UX dulu |
| Multi-bahasa | Indonesia only untuk v2 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| INFRA-01..07 | Phase 1 | Pending |
| UI-01..06 | Phase 2 | Pending |
| AUTH-01..09 | Phase 3 | Pending |
| UI-09 | Phase 3 | Pending |
| DASH-01..05 | Phase 4 | Pending |
| SOS-01..07 | Phase 4 | Pending |
| CHAT-01..04 | Phase 5 | Pending |
| RPT-01..04 | Phase 5 | Pending |
| DATA-01..09 | Phase 6 | Pending |
| UI-07, UI-08 | Phase 6 | Pending |
| PWA-01..05 | Phase 7 | Pending |
| SEC-01..05 | Phase 7 | Pending |

**Coverage:**
- v2.0 requirements: 55 total
- Mapped to phases: 55
- Unmapped: 0 ✓

---
*Requirements defined: 2026-05-08*
*Last updated: 2026-05-08 after tech stack pivot*
