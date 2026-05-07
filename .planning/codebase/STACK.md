# Tech Stack

## Production

| Layer | Technology | Version | Purpose |
|:------|:-----------|:--------|:--------|
| Framework | Next.js (App Router) | 15.x | Fullstack — SSR, API routes, middleware |
| Language | TypeScript | 5.x | Type safety, better DX |
| Styling | Vanilla CSS (Design System) | - | Glassmorphism, dark mode, responsive |
| ORM | Prisma | 6.x | Schema-as-code, migrations, type-safe queries |
| Database | PostgreSQL (Supabase) | 15 | Relational, RLS, free 500MB |
| Auth | Supabase Auth | - | JWT, bcrypt, OAuth-ready |
| Realtime | Supabase Realtime | - | WebSocket (chat, SOS broadcast) |
| Storage | Supabase Storage | - | File uploads, image CDN |
| PWA | @serwist/next | - | Service worker, offline, installable |
| Hosting | Vercel | - | Auto-deploy, CDN, serverless |

## Development

| Tool | Purpose |
|:-----|:--------|
| ESLint | Code linting (Next.js preset) |
| Prettier | Code formatting |
| Prisma Studio | Database GUI browser |
| Vercel CLI | Local dev, preview deploy |
| Git + GitHub | Version control |
| GSD | Project management workflow |

## External Services (All Free Tier)

| Service | Free Tier Limit | Usage |
|:--------|:----------------|:------|
| Supabase | 500MB DB, 1GB storage, 50K MAU | Database + Auth + Storage |
| Vercel | 100GB bandwidth, serverless | Hosting + API |
| GitHub | Unlimited repos | Version control |
