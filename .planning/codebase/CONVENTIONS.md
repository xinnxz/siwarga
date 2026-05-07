# Conventions

## Code Style

- **Language**: TypeScript strict mode (`strict: true`)
- **Formatting**: Prettier (2-space indent, single quotes, trailing commas)
- **Linting**: ESLint with Next.js recommended + Prisma plugin
- **Naming**: camelCase (variables/functions), PascalCase (components/types), SCREAMING_SNAKE (constants)
- **Files**: kebab-case for routes (`info-rt/page.tsx`), PascalCase for components (`ChatBubble.tsx`)

## Component Patterns

- Server Components by default (no `'use client'` unless needed)
- Client Components only for: interactivity, hooks, browser APIs
- Props interface defined above component
- Export default for page components, named export for shared components

## API Routes

- Always validate input with type guards
- Always check auth via `getServerSession()` or Supabase `getUser()`
- Return consistent response shape: `{ data, error, message }`
- Use Prisma for all DB operations (never raw SQL)
- Handle errors with try-catch, return appropriate HTTP status codes

## CSS

- Global design system via CSS custom properties in `variables.css`
- No inline styles except dynamic values (e.g., computed widths)
- Mobile-first media queries (`min-width` breakpoints)
- Dark mode via `body.dark-mode` class + CSS overrides
- BEM-like naming for custom classes (`.card__title`, `.nav--active`)

## Git

- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `style:`, `chore:`
- Branch: `main` (production), feature branches for development
- PR-based workflow when collaborating
