# Integrations

## Supabase (Primary Backend)

| Service | Usage | Config |
|:--------|:------|:-------|
| PostgreSQL | All data storage | via Prisma ORM |
| Auth | User authentication, JWT sessions | `@supabase/supabase-js` |
| Realtime | Live chat, SOS broadcast | WebSocket subscriptions |
| Storage | Image uploads (Info RT) | Bucket: `info-rt-images` |

**Connection**: Via `SUPABASE_URL` + `SUPABASE_ANON_KEY` (public) + `SUPABASE_SERVICE_ROLE_KEY` (server-side)

## Vercel (Hosting)

| Feature | Usage |
|:--------|:------|
| Edge Network | Static assets CDN |
| Serverless Functions | Next.js API routes |
| Auto-deploy | Push to `main` → deploy |
| Preview | PR branches get preview URLs |

## External CDN Dependencies

| Resource | URL | Purpose |
|:---------|:----|:--------|
| Google Fonts | `fonts.googleapis.com` | Poppins font family |

> **Note**: Bootstrap CSS dependency from v1.0 will be REMOVED. All styling via custom design system.
