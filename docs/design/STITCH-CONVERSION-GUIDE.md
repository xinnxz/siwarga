# Stitch → Flutter Conversion Guide

Telah diimplementasikan:

- **Design tokens** — [DESIGN-TOKENS.md](DESIGN-TOKENS.md)
- **Prompt siap pakai** — [STITCH-PROMPTS.md](STITCH-PROMPTS.md)
- **Widget dasar Flutter** — `siwarga_app/lib/core/widgets/` (`AppButton`, `AppCard`, `AppTextField`, `EmptyState`, `LoadingOverlay`, `UserAvatar`)
- **Tema** — `siwarga_app/lib/core/theme/` (warna selaras HTML legacy)

## Alur per layar

1. Pilih prompt dari `STITCH-PROMPTS.md`, tempel ke Stitch + prefix global di file yang sama.
2. Generate UI (HTML/Tailwind atau wireframe Stitch).
3. **Jangan** menyalin angka pixel mentah — rebuild layout di Flutter dengan `Theme.of(context)` spacing.
4. Gunakan widget shared di atas; jika perlu variasi, extend di `core/widgets/` (mis. `AppCard` dengan border kiri warna).
5. Uji **light / dark** dan **ukuran font** (tambahkan `MediaQuery.textScaler` di `MaterialApp` jika perlu skala ketiga).

## Prioritas layar (checklist)

- [ ] Home
- [ ] SOS
- [ ] Iuran (`DuesScreen`)
- [ ] Dashboard admin
- [ ] Agenda
- [ ] Login / Profil
- [ ] Chat
- [ ] Pengumuman (feed Home)
- [ ] Galeri
- [ ] Laporan

Centang saat UI Stitch sudah dipetakan ke screen Flutter dan lolos QA.
