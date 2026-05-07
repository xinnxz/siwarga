# SiWarga — Smart Community Platform

## What This Is

SiWarga adalah Progressive Web App (PWA) untuk manajemen komunitas perumahan/RT berbasis modern web stack. Platform ini mendigitalisasi seluruh aspek operasional RT — mulai dari SOS darurat, laporan warga, diskusi real-time, pengelolaan keuangan, hingga data kependudukan — dalam satu aplikasi yang bisa diakses dari perangkat apapun tanpa install. Dibangun dengan arsitektur yang siap scale ke multi-RT/RW/kelurahan sebagai produk SaaS.

## Core Value

**Memberikan akses komunikasi dan koordinasi darurat yang instan dan reliable bagi seluruh warga dalam satu komunitas residensial.**

## Requirements

### Validated

<!-- Fitur yang sudah terbukti berjalan dan dibutuhkan (dari production GAS v1.0) -->

- ✓ **Login/autentikasi** — warga butuh akses terkontrol
- ✓ **SOS darurat (4 kategori)** — fitur paling kritis untuk keselamatan
- ✓ **Diskusi/chat warga** — komunikasi komunitas harian
- ✓ **Laporan warga + status tracking** — pelaporan masalah ke pengurus
- ✓ **Kas keuangan (uang kematian)** — transparansi keuangan RT
- ✓ **CRUD data: warga, yatim, UMKM, kontrakan, tamu, ronda, info RT** — manajemen data
- ✓ **Pengaturan font & tema (dark/light)** — aksesibilitas
- ✓ **Dashboard + menu grid navigasi** — UX utama

### Active

<!-- v2.0 — Complete rebuild dengan tech stack profesional -->

- [ ] **PWA**: Installable, offline-capable, splash screen
- [ ] **Auth**: Registrasi invite code + verifikasi No Rumah, Supabase Auth
- [ ] **Realtime Chat**: Supabase Realtime subscriptions (live, bukan refresh)
- [ ] **SOS Upgrade**: Broadcast ke semua admin, logging, konfirmasi 2 langkah
- [ ] **UI Premium**: Glassmorphism, micro-animations, responsive 360px-1920px
- [ ] **Dashboard Stats**: Widget KPI (jumlah warga, laporan aktif, SOS bulan ini)
- [ ] **Database**: PostgreSQL (Supabase) + Prisma ORM + migration scripts
- [ ] **API Layer**: Next.js API Routes dengan Prisma
- [ ] **File Storage**: Supabase Storage untuk gambar (bukan base64)
- [ ] **Row-Level Security**: RBAC di level database (admin vs warga)

### Out of Scope (v2.0)

- **Flutter / React Native** — PWA sudah cukup, mobile-first responsive
- **Payment gateway** — Kas manual sesuai konteks RT
- **Video call / voice** — Bukan scope manajemen komunitas
- **AI chatbot** — Prioritas UX dan reliabilitas dulu
- **Multi-bahasa** — Bahasa Indonesia only
- **Google Sheets backend** — Digantikan PostgreSQL sepenuhnya

## Tech Stack

### Production Stack

| Layer | Technology | Version | Purpose |
|:------|:-----------|:--------|:--------|
| **Framework** | Next.js (App Router) | 15.x | Fullstack framework, SSR/SSG, API routes |
| **Language** | TypeScript | 5.x | Type safety, better DX |
| **Styling** | Vanilla CSS (Custom Design System) | - | Full kontrol glassmorphism, dark mode |
| **ORM** | Prisma | 6.x | Schema management, migrations, type-safe queries |
| **Database** | PostgreSQL (Supabase) | 15 | Relational DB, RLS, free tier |
| **Auth** | Supabase Auth | - | JWT, bcrypt, session management |
| **Realtime** | Supabase Realtime | - | WebSocket subscriptions (chat, SOS) |
| **Storage** | Supabase Storage | - | File uploads (gambar info RT) |
| **PWA** | @serwist/next | - | Service worker, offline, installable |
| **Hosting** | Vercel | - | Auto-deploy, CDN, serverless |

### Development Stack

| Tool | Purpose |
|:-----|:--------|
| ESLint + Prettier | Code quality & formatting |
| Git + GitHub | Version control |
| GSD (Get Shit Done) | Project management & workflow |
| Prisma Studio | Database GUI |
| Vercel CLI | Local dev & deployment |

## Context

- **Origin**: Evolusi dari SiWarga v1.0 (Google Apps Script + Sheets) yang sudah production
- **Users**: Warga RT 05 (~50-100 KK), banyak yang kurang melek teknologi
- **Vision**: Produk SaaS multi-RT/RW/kelurahan — scalable ke level kota
- **Business Model**: Freemium per RT → investor-ready
- **Existing Data**: 12 Google Sheets (akan dimigrasikan atau diinput ulang)
- **Existing Docs**: 6 dokumen arsitektur (~95KB) — sebagai referensi fitur

## Constraints

- **Budget**: Rp 0 pada fase development (free tier semua service)
- **Compatibility**: Chrome 90+, Safari 15+, Edge 90+ (mobile & desktop)
- **Performance**: LCP < 2.5s, FID < 100ms pada koneksi 4G
- **Accessibility**: Font scalable, kontras WCAG AA, touch targets ≥ 44px
- **Security**: No plaintext passwords, RLS enforced, input sanitization
- **Offline**: Core pages accessible offline via service worker cache

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| PWA over Flutter | Zero install friction, universal access, cheaper development | — Pending |
| Next.js fullstack | API routes + Prisma built-in, developer sudah experienced (GoTani) | — Pending |
| Supabase over Firebase | PostgreSQL + Prisma > NoSQL, free tier generous, RLS superior | — Pending |
| Prisma ORM | Type-safe queries, schema-as-code, migration management | — Pending |
| Invite Code + No Rumah registration | 2-layer verification: kode dari grup WA RT + No Rumah match di DB | — Pending |
| Vercel hosting | Free, auto-deploy from Git, optimal untuk Next.js | — Pending |
| Fresh database (no GAS migration) | Clean start, proper schema design, data akan diinput ulang | — Pending |
| Vanilla CSS over Tailwind | Full kontrol glassmorphism design system, no dependency | — Pending |

---
*Last updated: 2026-05-08 after tech stack pivot to Next.js + Supabase + Prisma*
