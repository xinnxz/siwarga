# Project Structure

```
siwarga/
├── public/
│   ├── icons/                  # PWA icons (192x192, 512x512)
│   ├── favicon.ico
│   └── manifest.json           # PWA manifest
│
├── prisma/
│   ├── schema.prisma           # Database schema (source of truth)
│   ├── migrations/             # Prisma migration history
│   └── seed.ts                 # Seed data for development
│
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── layout.tsx          # Root layout (fonts, metadata)
│   │   ├── page.tsx            # Landing / redirect to dashboard
│   │   ├── globals.css         # CSS imports aggregator
│   │   ├── (auth)/             # Auth route group
│   │   │   ├── login/page.tsx
│   │   │   └── register/page.tsx
│   │   ├── (app)/              # Authenticated route group
│   │   │   ├── layout.tsx      # App shell (nav, header)
│   │   │   ├── dashboard/page.tsx
│   │   │   ├── sos/page.tsx
│   │   │   ├── chat/page.tsx
│   │   │   ├── laporan/page.tsx
│   │   │   ├── warga/page.tsx
│   │   │   ├── kas/page.tsx
│   │   │   ├── umkm/page.tsx
│   │   │   ├── ronda/page.tsx
│   │   │   ├── tamu/page.tsx
│   │   │   ├── yatim/page.tsx
│   │   │   ├── kontrakan/page.tsx
│   │   │   ├── info-rt/page.tsx
│   │   │   └── settings/page.tsx
│   │   └── api/                # API Routes
│   │       ├── auth/
│   │       ├── sos/
│   │       ├── chat/
│   │       ├── reports/
│   │       ├── residents/
│   │       ├── announcements/
│   │       ├── kas/
│   │       ├── umkm/
│   │       ├── ronda/
│   │       ├── tamu/
│   │       ├── yatim/
│   │       ├── kontrakan/
│   │       ├── info-rt/
│   │       └── invite-codes/
│   │
│   ├── components/             # Reusable UI components
│   │   ├── ui/                 # Design system primitives
│   │   │   ├── Button.tsx
│   │   │   ├── Card.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── Badge.tsx
│   │   │   ├── Modal.tsx
│   │   │   ├── Skeleton.tsx
│   │   │   └── EmptyState.tsx
│   │   ├── layout/
│   │   │   ├── BottomNav.tsx
│   │   │   ├── Header.tsx
│   │   │   └── PageHeader.tsx
│   │   └── features/           # Feature-specific components
│   │       ├── ChatBubble.tsx
│   │       ├── SOSButton.tsx
│   │       ├── StatsCard.tsx
│   │       └── StatusBadge.tsx
│   │
│   ├── css/                    # Design system stylesheets
│   │   ├── variables.css       # CSS custom properties
│   │   ├── base.css            # Reset, typography, global
│   │   ├── components.css      # Component styles
│   │   ├── pages.css           # Page-specific styles
│   │   ├── animations.css      # Keyframes, transitions
│   │   └── dark-mode.css       # Dark theme overrides
│   │
│   ├── lib/                    # Shared utilities
│   │   ├── prisma.ts           # Prisma client singleton
│   │   ├── supabase/
│   │   │   ├── server.ts       # Server-side Supabase client
│   │   │   └── client.ts       # Browser-side Supabase client
│   │   ├── auth.ts             # Auth helpers
│   │   └── utils.ts            # Format, sanitize, etc.
│   │
│   ├── hooks/                  # Custom React hooks
│   │   ├── useAuth.ts
│   │   ├── useRealtime.ts
│   │   └── useTheme.ts
│   │
│   └── types/                  # TypeScript type definitions
│       ├── database.ts         # Prisma-generated types
│       └── api.ts              # API request/response types
│
├── docs/                       # Architecture documentation
│   └── architecture/           # (existing 6 docs)
│
├── .planning/                  # GSD project management
│   ├── PROJECT.md
│   ├── REQUIREMENTS.md
│   ├── ROADMAP.md
│   ├── STATE.md
│   └── codebase/
│
├── .env.local                  # Environment variables (gitignored)
├── .eslintrc.json
├── .prettierrc
├── .gitignore
├── next.config.ts
├── tsconfig.json
├── package.json
└── README.md
```

## Database Schema (PostgreSQL via Prisma)

### Core Tables

| Table | Purpose | Key Columns |
|:------|:--------|:------------|
| `users` | Registered accounts | id, email, name, role, house_number, is_active |
| `invite_codes` | Registration codes | code, created_by, expires_at, max_uses, used_count |
| `announcements` | Pengumuman RT | title, content, author_id, created_at |
| `reports` | Laporan warga | content, reporter_id, status, admin_response |
| `sos_logs` | SOS emergency log | user_id, category, message, status, created_at |
| `chats` | Diskusi messages | sender_id, message, created_at |
| `residents` | Data warga | name, house_number, phone, status |
| `kas` | Keuangan | type(in/out), amount, balance, description |
| `umkm` | UMKM directory | business_name, owner, house_number, description |
| `yatim` | Data anak yatim | name, age, house_number |
| `kontrakan` | Kontrakan status | house_number, status(kosong/isi) |
| `tamu` | Buku tamu | guest_name, reporter, purpose, visit_date |
| `ronda` | Jadwal ronda | day, officers |
| `info_rt` | Info + gambar | title, image_url, created_at |
