# 📋 05 — Feature Specifications

> **Version**: 1.0.0 | **Updated**: 2026-04-28

---

## Feature Priority Matrix

| Phase | Feature | Priority | Complexity | Dependencies |
|-------|---------|----------|------------|--------------|
| MVP | Auth (Login) | 🔴 P0 | Medium | Firebase Auth |
| MVP | Beranda | 🔴 P0 | Medium | Auth |
| MVP | SOS Darurat | 🔴 P0 | High | Auth, FCM |
| MVP | Lapor Warga | 🟡 P1 | Low | Auth |
| MVP | Diskusi | 🟡 P1 | Medium | Auth |
| MVP | Pengaturan | 🟢 P2 | Low | Auth |
| Phase 2 | Pengumuman RT | 🟡 P1 | Low | Auth, RBAC |
| Phase 2 | Data Kontrakan | 🟢 P2 | Low | Auth, RBAC |
| Phase 2 | Buku Tamu | 🟢 P2 | Low | Auth |
| Phase 2 | Data Anak Yatim | 🟢 P2 | Low | Auth, RBAC |
| Phase 3 | Keuangan | 🟡 P1 | High | Auth, RBAC |
| Phase 3 | UMKM | 🟢 P2 | Medium | Auth |

---

## FEAT-001: Authentication System

### Overview
Sistem login tertutup dimana hanya admin yang bisa mendaftarkan warga baru.

### User Stories
- **US-001**: Sebagai Admin, saya bisa mendaftarkan warga baru agar mereka bisa menggunakan aplikasi
- **US-002**: Sebagai Warga, saya bisa login dengan email dan password yang diberikan admin
- **US-003**: Sebagai Warga, saya bisa mengubah password saya sendiri
- **US-004**: Sebagai Admin, saya bisa reset password warga jika lupa

### Screens

#### Login Screen
```
┌─────────────────────────────┐
│                             │
│      🏠 SiWarga RT.05      │
│    Sistem Warga Digital     │
│                             │
│  ┌───────────────────────┐  │
│  │ Email                 │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ Password          👁  │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │       M A S U K       │  │
│  └───────────────────────┘  │
│                             │
│     Lupa password?          │
│                             │
│  ─────────────────────────  │
│  Hubungi Ketua RT untuk     │
│  mendapatkan akun           │
│                             │
└─────────────────────────────┘
```

#### Admin: Register Warga Screen
```
┌─────────────────────────────┐
│  ← Tambah Warga             │
│                             │
│  Nama Lengkap *             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  NIK *                      │
│  ┌───────────────────────┐  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  No HP *                    │
│  ┌───────────────────────┐  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  Nomor Rumah *              │
│  ┌───────────────────────┐  │
│  │ RT05-___              │  │
│  └───────────────────────┘  │
│                             │
│  Email Login *              │
│  ┌───────────────────────┐  │
│  │ auto: nik@siwarga.rt05│  │
│  └───────────────────────┘  │
│                             │
│  Password Awal *            │
│  ┌───────────────────────┐  │
│  │ (auto-generated)      │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │   DAFTARKAN WARGA     │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

### Acceptance Criteria
- [ ] Warga bisa login dengan email + password
- [ ] Login gagal menampilkan error message yang jelas
- [ ] Admin bisa register warga baru
- [ ] Password minimal 6 karakter
- [ ] Session persist (tidak perlu login ulang)
- [ ] Logout membersihkan session & FCM token
- [ ] 5x login gagal → temporary lockout 5 menit

---

## FEAT-002: Beranda (Home)

### Overview
Halaman utama setelah login. Menampilkan profil, data warga, pengumuman, dan akses ke sub-fitur.

### Screen Layout
```
┌─────────────────────────────┐
│  ┌─────┐                    │
│  │FOTO │ Ahmad Fauzi        │
│  │     │ 0812-xxxx-xxxx     │
│  │     │ NIK: ********0123  │
│  └─────┘ Rumah: RT05-012    │
│                             │
│  ┌──── MENU UTAMA ────────┐ │
│  │                         │ │
│  │  📊 Data   🏠 Info     │ │
│  │  Warga    Kontrakan     │ │
│  │                         │ │
│  │  📢 Info   👶 Anak     │ │
│  │  RT       Yatim         │ │
│  │                         │ │
│  │  📝 Buku  💰 Keuangan  │ │
│  │  Tamu                   │ │
│  │                         │ │
│  │  🏪 UMKM               │ │
│  │  Warga                  │ │
│  └─────────────────────────┘ │
│                             │
│  ── Info RT (Feed) ──────── │
│  ┌─────────────────────────┐│
│  │ 📢 Jadwal Kerja Bakti   ││
│  │ Pak RT • 2 jam lalu     ││
│  │ Kerja bakti dilaksana...││
│  └─────────────────────────┘│
│  ┌─────────────────────────┐│
│  │ 📢 Iuran Bulan April    ││
│  │ Pak RT • 1 hari lalu    ││
│  └─────────────────────────┘│
│                             │
├─────┬──────┬──────┬────┬────┤
│ 🏠  │  📝  │ 🚨  │ 💬 │ ⚙️ │
│Home │Lapor │ SOS  │Chat│Set │
└─────┴──────┴──────┴────┴────┘
```

### Acceptance Criteria
- [ ] Profil user ditampilkan di atas (nama, hp, NIK masked, no rumah)
- [ ] Grid menu navigasi ke sub-fitur
- [ ] Feed pengumuman RT (scrollable, terbaru di atas)
- [ ] Pull-to-refresh untuk update data
- [ ] Offline: tampilkan data cache terakhir

---

## FEAT-003: SOS Darurat (Core Feature)

### Overview
Tombol darurat yang mengirim notifikasi + sirine ke semua warga.

### Screen Flow
```
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│                  │    │                  │    │                  │
│                  │    │  Pilih Jenis:    │    │  ⚠️ KONFIRMASI   │
│                  │    │                  │    │                  │
│    ┌────────┐    │    │  🔓 Maling      │    │  Anda akan       │
│    │  🚨   │    │───►│  🏠 KDRT        │───►│  mengirim SOS    │
│    │  SOS   │    │    │  🔥 Kebakaran   │    │  ke seluruh      │
│    │ DARURAT│    │    │  🚗 Kecelakaan  │    │  warga RT.05     │
│    └────────┘    │    │  ❓ Lainnya     │    │                  │
│                  │    │                  │    │  [BATAL] [KIRIM] │
│  ⚠ Gunakan hanya│    │                  │    │     (3 detik)    │
│  saat darurat!   │    │                  │    │                  │
│                  │    │                  │    │                  │
└──────────────────┘    └──────────────────┘    └──────────────────┘

                        ┌──────────────────┐
                        │                  │
                  ┌─────│  🔴 SOS AKTIF   │
                  │     │                  │
  Tampilan di     │     │  Ahmad Fauzi     │
  semua device ───┘     │  Rumah: RT05-012 │
                        │  Jenis: MALING   │
                        │  22:30 WIB       │
                        │                  │
                        │  🔊 SIRINE ON   │
                        │                  │
                        │  [Lihat Detail]  │
                        └──────────────────┘
```

### Technical Requirements
- FCM notification with `priority: high` and `android.priority: high`
- Notification channel: `sos_channel` with importance MAX
- Siren audio: loop until user dismisses or admin resolves
- Rate limit: max 3 per hour, 5 min cooldown
- SOS log: NEVER deleted (permanent audit trail)

### Acceptance Criteria
- [ ] Tombol SOS prominent di tengah navbar
- [ ] Wajib pilih kategori sebelum kirim
- [ ] Dialog konfirmasi dengan countdown 3 detik
- [ ] Notifikasi diterima semua device dalam < 5 detik
- [ ] Suara sirine berbunyi saat notif diterima
- [ ] Info pelapor (nama, rumah, jenis, waktu) tampil
- [ ] Admin bisa resolve/deactivate SOS
- [ ] Rate limiting mencegah spam
- [ ] Bekerja saat app di background

---

## FEAT-004: Lapor Warga

### Overview
Form pelaporan untuk masalah non-darurat (jalan rusak, lampu mati, dll).

### Screen Layout
```
┌─────────────────────────────┐
│  ← Lapor Warga              │
│                             │
│  ── Daftar Laporan ──────── │
│                             │
│  ┌─────────────────────────┐│
│  │ 🟡 Lampu Jalan Mati     ││
│  │ Ahmad • RT05-012        ││
│  │ 28 Apr 2026 • 10:30     ││
│  │ Status: Pending          ││
│  └─────────────────────────┘│
│  ┌─────────────────────────┐│
│  │ 🟢 Jalan Berlubang      ││
│  │ Budi • RT05-005         ││
│  │ 27 Apr 2026 • 14:00     ││
│  │ Status: Selesai          ││
│  └─────────────────────────┘│
│                             │
│         ┌───────────┐       │
│         │  + LAPOR  │       │
│         └───────────┘       │
├─────┬──────┬──────┬────┬────┤
│ 🏠  │  📝  │ 🚨  │ 💬 │ ⚙️ │
└─────┴──────┴──────┴────┴────┘
```

### Acceptance Criteria
- [ ] Daftar laporan dengan filter (status, kategori)
- [ ] Form lapor: judul, deskripsi, kategori, foto (opsional)
- [ ] Setelah lapor, otomatis tampil di daftar
- [ ] Admin bisa update status (pending → ditangani → selesai)
- [ ] Notifikasi ke pelapor saat status berubah

---

## FEAT-005: Diskusi Warga

### Overview
Chat grup untuk komunikasi antar warga RT.

### Screen Layout
```
┌─────────────────────────────┐
│  💬 Diskusi Warga RT.05     │
│                             │
│  ┌─────────────────────────┐│
│  │👤 Ahmad           10:30 ││
│  │  Tadi malam ada suara   ││
│  │  aneh di belakang rumah  ││
│  │  nomor 15               ││
│  └─────────────────────────┘│
│                             │
│        ┌───────────────────┐│
│        │     Budi    10:32 ││
│        │ Iya pak saya juga ││
│        │ dengar            ││
│        └───────────────────┘│
│                             │
│  ┌─────────────────────────┐│
│  │👤 Pak RT          10:35 ││
│  │  Sudah saya cek, itu    ││
│  │  kucing tetangga 🐱     ││
│  └─────────────────────────┘│
│                             │
│  ┌───────────────────┬────┐ │
│  │ Ketik pesan...    │ ➤  │ │
│  └───────────────────┴────┘ │
├─────┬──────┬──────┬────┬────┤
│ 🏠  │  📝  │ 🚨  │ 💬 │ ⚙️ │
└─────┴──────┴──────┴────┴────┘
```

### Acceptance Criteria
- [ ] Realtime messaging (pesan langsung muncul)
- [ ] Tampil nama, foto, dan waktu pengirim
- [ ] Support text dan gambar
- [ ] Scroll ke pesan terbaru otomatis
- [ ] Bisa hapus pesan sendiri
- [ ] Admin bisa hapus pesan siapapun
- [ ] Pagination (load more saat scroll ke atas)

---

## FEAT-006: Pengaturan

### Screen Layout
```
┌─────────────────────────────┐
│  ⚙️ Pengaturan               │
│                             │
│  ── Akun ─────────────────  │
│  👤 Edit Profil          >  │
│  🔑 Ubah Password        >  │
│                             │
│  ── Notifikasi ───────────  │
│  🔔 Notifikasi SOS    [ON]  │
│  📢 Notifikasi Info   [ON]  │
│  💬 Notifikasi Chat   [ON]  │
│                             │
│  ── Tentang ──────────────  │
│  ℹ️  Tentang Aplikasi     >  │
│  📄 Kebijakan Privasi    >  │
│  🆘 Bantuan              >  │
│                             │
│  ── Lainnya ──────────────  │
│  🚪 Keluar (Logout)      >  │
│                             │
│  v1.0.0 • SiWarga RT.05    │
├─────┬──────┬──────┬────┬────┤
│ 🏠  │  📝  │ 🚨  │ 💬 │ ⚙️ │
└─────┴──────┴──────┴────┴────┘
```

### Acceptance Criteria
- [ ] Edit profil (nama, foto, no HP)
- [ ] Ubah password
- [ ] Toggle notifikasi per kategori
- [ ] Logout dengan konfirmasi
- [ ] Tampilkan versi aplikasi
