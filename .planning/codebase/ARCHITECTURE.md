# Architecture

## System Overview

```
┌─────────────┐     HTTPS      ┌──────────────┐     TCP       ┌────────────────┐
│   Browser    │ ◄────────────► │   Vercel      │ ◄──────────► │   Supabase     │
│   (PWA)      │                │   (Next.js)   │              │   (PostgreSQL) │
│              │                │              │              │   + Auth       │
│  - React     │   SSR/API      │  - Pages      │   Prisma     │   + Realtime   │
│  - CSS       │   Routes       │  - API Routes │   ORM        │   + Storage    │
│  - SW Cache  │                │  - Middleware  │              │                │
└─────────────┘                └──────────────┘              └────────────────┘
```

## Data Flow

1. **Read**: Browser → Next.js API Route → Prisma → Supabase PostgreSQL → JSON response
2. **Write**: Browser → API Route (validate + sanitize) → Prisma → PostgreSQL
3. **Realtime**: Browser ← Supabase Realtime WebSocket (chat, SOS broadcast)
4. **Auth**: Browser → Supabase Auth SDK → JWT token → API middleware validates
5. **Files**: Browser → API Route → Supabase Storage → CDN URL returned

## Key Patterns

| Pattern | Implementation |
|:--------|:---------------|
| Server Components | Default for pages — data fetching on server |
| Client Components | Interactive UI only (`'use client'`) |
| API Routes | `/api/*` — Prisma queries, auth checks |
| Middleware | `middleware.ts` — auth redirect, role check |
| Singleton Prisma | `lib/prisma.ts` — prevents connection exhaustion |
| RLS | Supabase Row-Level Security on all tables |
| CSS Modules / Global | Global design system + scoped overrides |
