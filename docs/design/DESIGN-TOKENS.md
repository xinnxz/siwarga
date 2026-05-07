# Design Tokens — SiWarga RT.05

Sumber kebenaran untuk **Stitch prompts**, **Flutter** (`siwarga_app/lib/core/theme/`), dan dokumentasi UI.

---

## Brand colors

| Token | Hex | Usage |
|-------|-----|--------|
| `primary` | `#1a237e` | Header gradient start, primary buttons, links |
| `primary2` | `#283593` | Gradient mid |
| `primary3` | `#3949ab` | Gradient end, accents |
| `danger` | `#c62828` | SOS, destructive, alerts |
| `success` | `#2e7d32` | Success states, “lunas”, masuk kas |
| `warning` | `#f57f17` | Warnings, pending |
| `surfaceLight` | `#f0f2f8` | Page background (light) |
| `surfaceDark` | `#0f1117` | Page background (dark) |
| `cardLight` | `#ffffff` | Cards (light) |
| `cardDark` | `#1c1c2e` | Cards (dark) |

---

## Typography

| Token | Font | Notes |
|-------|------|--------|
| Family | **Poppins** | Google Fonts weights 300, 400, 500, 600, 700 |
| Scale `xs`–`xl` | Responsive | Di web legacy memakai `vw`; di Flutter gunakan `Theme.of(context).textTheme` + `MediaQuery.textScaler` |

### Font size presets (accessibility)

| Preset | Purpose |
|--------|---------|
| `kecil` | Elder-friendly smaller base (inverse — actually “smaller UI”; legacy names kept in app as user-facing) |
| `normal` | Default |
| `besar` | Larger tap targets & text |

Legacy mapping from `index.html`: classes `font-kecil`, `font-normal`, `font-besar` on `body`.

---

## Spacing & radius

| Token | Value | Usage |
|-------|-------|--------|
| `radiusSm` | 8px | Chips |
| `radiusMd` | 14px | Cards (`--radius`) |
| `radiusLg` | 24px | Bottom sheets, large panels |
| `radiusPill` | 999px | Buttons “pill”, badges |
| `spaceXs` | 4px | Tight gaps |
| `spaceSm` | 8px | Inline spacing |
| `spaceMd` | 16px | Section padding |
| `spaceLg` | 24px | Screen horizontal padding |

---

## Elevation / shadow

| Level | Light mode |
|-------|------------|
| Card | `0 2px 8px rgba(0,0,0,0.05)` |
| Header | `0 6px 20px rgba(26,35,126,0.25)` |
| FAB / SOS | Pulse animation optional; shadow red tint |

---

## Semantic colors (dark mode)

Mirror pairs from `index.html` `body.dark-mode`: text `#e8e8f0`, borders `#2a2a40`, inputs `#252545`.

---

## Icon set

**Bootstrap Icons** (legacy web). Flutter: `Icons.*` from Material Symbols or `bootstrap_icons` package where parity matters.

---

## Stitch → Flutter mapping

| Stitch / HTML concept | Flutter |
|-----------------------|---------|
| Tailwind `rounded-[14px]` | `BorderRadius.circular(14)` |
| `max-w-[600px]` centered | `Center` + `ConstrainedBox(maxWidth: 600)` |
| Sticky bottom bar | `BottomNavigationBar` or `NavigationBar` |
| `vw` font sizes | `Theme` + `textScaler` / `MediaQuery` |
