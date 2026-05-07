# Roadmap: SiWarga v2.0

## Overview

Complete rebuild SiWarga dari GAS monolith ke modern fullstack PWA. Dimulai dari setup infrastruktur (Next.js + Supabase + Prisma), lalu design system, auth, fitur inti, dan diakhiri PWA finalization. Target: produk investor-ready yang bisa scale ke multi-RT.

## Phases

- [ ] **Phase 1: Project Foundation** - Next.js + Supabase + Prisma setup, database schema
- [ ] **Phase 2: Design System** - CSS architecture, glassmorphism components, responsive
- [ ] **Phase 3: Auth System** - Login, register (invite code), Supabase Auth, protected routes
- [ ] **Phase 4: Dashboard & SOS** - Stats widgets, SOS broadcast + logging
- [ ] **Phase 5: Chat & Laporan** - Realtime chat, reporting system
- [ ] **Phase 6: Data Modules** - CRUD semua modul (warga, kas, UMKM, ronda, dll)
- [ ] **Phase 7: PWA & Security** - Service worker, offline, RLS, hardening

## Phase Details

### Phase 1: Project Foundation
**Goal**: Infrastruktur lengkap — Next.js running, Prisma connected to Supabase PostgreSQL, database schema migrated
**Depends on**: Nothing (first phase)
**Requirements**: INFRA-01, INFRA-02, INFRA-03, INFRA-04, INFRA-05, INFRA-06, INFRA-07
**Success Criteria** (what must be TRUE):
  1. `npm run dev` menjalankan Next.js dengan TypeScript tanpa error
  2. Prisma schema mendefinisikan semua tabel (users, announcements, reports, sos_logs, chats, residents, kas, umkm, yatim, kontrakan, tamu, ronda, info_rt, invite_codes)
  3. `npx prisma migrate dev` berhasil create semua tabel di Supabase PostgreSQL
  4. `npx prisma studio` menampilkan semua tabel dengan benar
  5. Vercel deployment berhasil (auto-deploy dari GitHub push)
  6. ESLint + Prettier berjalan tanpa error
**Plans**: 3 plans

Plans:
- [ ] 01-01: Next.js + TypeScript initialization, ESLint, Prettier, folder structure
- [ ] 01-02: Supabase project setup, Prisma config, database schema design
- [ ] 01-03: Prisma migration, seed data, Vercel deployment

### Phase 2: Design System
**Goal**: Fondasi visual premium — CSS custom properties, glassmorphism components, responsive layout, dark/light mode
**Depends on**: Phase 1
**Requirements**: UI-01, UI-02, UI-03, UI-04, UI-05, UI-06
**Success Criteria** (what must be TRUE):
  1. CSS variables terdefinisi lengkap (colors, fonts, spacing, radius, shadows, glass)
  2. Component library berfungsi: card, button, input, nav, badge, modal, skeleton
  3. Glassmorphism effect tampil di semua card components
  4. Responsive dari 360px (mobile kecil) hingga 1920px (desktop)
  5. Bottom nav responsive dengan animated active indicator
  6. Dark mode dan light mode keduanya terasa premium
  7. Micro-animations aktif (transitions, hover, focus)
**Plans**: 3 plans

Plans:
- [ ] 02-01: CSS variables, color palette, typography, base styles
- [ ] 02-02: Component library — card, button, input, badge, modal, nav
- [ ] 02-03: Responsive breakpoints, dark mode, micro-animations

### Phase 3: Auth System
**Goal**: Authentication lengkap — login, register dengan invite code + no rumah verification, protected routes
**Depends on**: Phase 2
**Requirements**: AUTH-01..09, UI-09
**Success Criteria** (what must be TRUE):
  1. Login page premium dengan branding SiWarga
  2. Register page: input invite code → validasi → input data diri → create account
  3. Supabase Auth handles password hashing (bcrypt) otomatis
  4. Session persists di browser (refresh tidak logout)
  5. Protected pages redirect ke login jika belum authenticated
  6. Role-based UI: admin melihat panel admin, warga hanya fitur warga
  7. Admin bisa generate invite codes dari panel
**Plans**: 3 plans

Plans:
- [ ] 03-01: Supabase Auth integration, API routes (login, register, session)
- [ ] 03-02: Login + Register UI pages dengan design system
- [ ] 03-03: Protected routes middleware, admin panel invite code management

### Phase 4: Dashboard & SOS
**Goal**: Dashboard informatif dengan statistik real-time dan SOS broadcast system
**Depends on**: Phase 3
**Requirements**: DASH-01..05, SOS-01..07
**Success Criteria** (what must be TRUE):
  1. Dashboard menampilkan stats cards (total warga, laporan aktif, SOS bulan ini)
  2. Quick action buttons (SOS, Lapor, Chat) responsif
  3. Pengumuman feed menampilkan 5 terbaru
  4. SOS button pulse animation berfungsi
  5. Konfirmasi 2 langkah sebelum SOS terkirim
  6. SOS broadcast via Supabase Realtime ke semua admin
  7. SOS log tersimpan di database
  8. Admin bisa lihat riwayat SOS
**Plans**: 2 plans

Plans:
- [ ] 04-01: Dashboard layout, stats API, pengumuman feed, menu grid
- [ ] 04-02: SOS system — broadcast, logging, riwayat, WhatsApp fallback

### Phase 5: Chat & Laporan
**Goal**: Real-time chat dan sistem pelaporan warga
**Depends on**: Phase 4
**Requirements**: CHAT-01..04, RPT-01..04
**Success Criteria** (what must be TRUE):
  1. Chat real-time via Supabase Realtime (pesan muncul tanpa refresh)
  2. Chat bubble UI (mine/other) dengan sender name dan timestamp
  3. Scroll-to-bottom button berfungsi
  4. Laporan form bisa disubmit oleh semua warga
  5. Status badge visual (Pending/Diproses/Selesai/Ditolak)
  6. Admin bisa update status dan tambah response
**Plans**: 2 plans

Plans:
- [ ] 05-01: Realtime chat — Supabase subscription, UI, scroll behavior
- [ ] 05-02: Reporting system — form, status lifecycle, admin response

### Phase 6: Data Modules
**Goal**: Semua modul data CRUD berfungsi dengan design system konsisten
**Depends on**: Phase 5
**Requirements**: DATA-01..09, UI-07, UI-08
**Success Criteria** (what must be TRUE):
  1. CRUD berfungsi untuk semua 9 modul data
  2. Admin-only forms gated berdasarkan role
  3. Empty states menggunakan ilustrasi/icon
  4. Loading skeletons muncul saat fetching
  5. Image upload (Info RT) menggunakan Supabase Storage
  6. Semua halaman konsisten menggunakan design system
**Plans**: 3 plans

Plans:
- [ ] 06-01: Warga, Kas, Pengumuman — API routes + UI
- [ ] 06-02: Tamu, UMKM, Yatim, Kontrakan — API routes + UI
- [ ] 06-03: Ronda, Info RT (with Storage upload), empty states, skeletons

### Phase 7: PWA & Security
**Goal**: App installable, offline-capable, dan security hardened
**Depends on**: Phase 6
**Requirements**: PWA-01..05, SEC-01..05
**Success Criteria** (what must be TRUE):
  1. Manifest.json terkonfigurasi (icons, theme, splash)
  2. Service worker caching static assets
  3. App installable dari Chrome/Safari
  4. Offline fallback page berfungsi
  5. RLS policies aktif di semua tabel Supabase
  6. Input sanitization di semua form
  7. Rate limiting aktif pada login dan SOS endpoints
**Plans**: 2 plans

Plans:
- [ ] 07-01: PWA setup — manifest, service worker, icons, offline page
- [ ] 07-02: Security hardening — RLS policies, sanitization, rate limiting

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Project Foundation | 0/3 | Not started | - |
| 2. Design System | 0/3 | Not started | - |
| 3. Auth System | 0/3 | Not started | - |
| 4. Dashboard & SOS | 0/2 | Not started | - |
| 5. Chat & Laporan | 0/2 | Not started | - |
| 6. Data Modules | 0/3 | Not started | - |
| 7. PWA & Security | 0/2 | Not started | - |
