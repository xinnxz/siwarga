# 🗄️ 02 — Database Design

> **Version**: 1.0.0 | **Updated**: 2026-04-28

---

## 1. Database Type

**Cloud Firestore** — NoSQL Document Database

> **Kenapa Firestore?**
> - Realtime listeners (data update otomatis di UI)
> - Offline persistence built-in
> - Scalable tanpa manage server
> - Free tier cukup untuk skala RT

---

## 2. Collection Schema

### 2.1 `users` — Data Warga

```json
{
  "uid": "firebase_auth_uid",
  "nama": "Ahmad Fauzi",
  "email": "ahmad@siwarga.rt05",
  "no_hp": "081234567890",
  "nik": "3201xxxxxxxxxxxx",
  "nomor_rumah": "RT05-012",
  "alamat": "Jl. Mawar No. 12",
  "foto_url": "https://storage.firebase.com/...",
  "role": "warga",
  "rt_id": "rt05_rw05",
  "fcm_token": "device_fcm_token_here",
  "is_active": true,
  "created_at": "2026-04-28T10:00:00Z",
  "updated_at": "2026-04-28T10:00:00Z"
}
```

| Field | Type | Required | Index | Description |
|-------|------|----------|-------|-------------|
| uid | string | ✅ | PK | Firebase Auth UID |
| nama | string | ✅ | ✅ | Nama lengkap warga |
| email | string | ✅ | ✅ | Email login |
| no_hp | string | ✅ | - | Nomor telepon |
| nik | string | ✅ | ✅ | NIK (encrypted) |
| nomor_rumah | string | ✅ | ✅ | Nomor rumah di RT |
| alamat | string | - | - | Alamat lengkap |
| foto_url | string | - | - | URL foto profil |
| role | string | ✅ | ✅ | `warga` / `admin` / `super_admin` |
| rt_id | string | ✅ | ✅ | Identifier RT (multi-tenant ready) |
| fcm_token | string | - | - | Push notification token |
| is_active | bool | ✅ | ✅ | Akun aktif/nonaktif |
| created_at | timestamp | ✅ | ✅ | Tanggal registrasi |
| updated_at | timestamp | ✅ | - | Last update |

**Roles:**
- `warga` — Akses standar (lapor, diskusi, SOS)
- `admin` — Ketua RT (manage warga, kirim pengumuman, moderasi)
- `super_admin` — Developer/system admin

---

### 2.2 `reports` — Laporan Warga

```json
{
  "id": "auto_generated_id",
  "user_id": "firebase_auth_uid",
  "nama_pelapor": "Ahmad Fauzi",
  "nomor_rumah": "RT05-012",
  "judul": "Lampu Jalan Mati",
  "isi_laporan": "Lampu di depan rumah nomor 15 sudah mati 3 hari",
  "kategori": "lampu_mati",
  "foto_urls": ["https://storage..."],
  "status": "pending",
  "admin_response": "",
  "rt_id": "rt05_rw05",
  "created_at": "2026-04-28T10:00:00Z",
  "resolved_at": null
}
```

| Field | Type | Description |
|-------|------|-------------|
| id | string | Auto-generated doc ID |
| user_id | string | UID pelapor |
| nama_pelapor | string | Nama (denormalized for display) |
| nomor_rumah | string | Rumah pelapor |
| judul | string | Ringkasan laporan |
| isi_laporan | string | Detail laporan |
| kategori | enum | `jalan_rusak`, `lampu_mati`, `hewan_berbahaya`, `sampah`, `lainnya` |
| foto_urls | array | Max 3 foto lampiran |
| status | enum | `pending` → `ditangani` → `selesai` |
| admin_response | string | Tanggapan dari admin |
| rt_id | string | Multi-tenant ID |
| created_at | timestamp | Waktu lapor |
| resolved_at | timestamp | Waktu selesai |

---

### 2.3 `emergencies` — Log Darurat (SOS)

```json
{
  "id": "auto_generated_id",
  "user_id": "firebase_auth_uid",
  "nama_pelapor": "Ahmad Fauzi",
  "nomor_rumah": "RT05-012",
  "jenis_darurat": "maling",
  "deskripsi": "Ada orang mencurigakan mencoba masuk lewat pagar belakang",
  "is_active": true,
  "rt_id": "rt05_rw05",
  "created_at": "2026-04-28T22:30:00Z",
  "resolved_at": null,
  "resolved_by": null
}
```

| Field | Type | Description |
|-------|------|-------------|
| jenis_darurat | enum | `maling`, `kdrt`, `kebakaran`, `kecelakaan`, `bencana`, `lainnya` |
| is_active | bool | `true` = darurat aktif, `false` = sudah ditangani |
| resolved_by | string | UID admin yang menangani |

---

### 2.4 `discussions` — Diskusi Warga

```json
{
  "id": "auto_generated_id",
  "user_id": "firebase_auth_uid",
  "nama_pengirim": "Ahmad Fauzi",
  "nomor_rumah": "RT05-012",
  "foto_pengirim": "https://...",
  "pesan": "Tadi malam listrik padam lagi ya pak?",
  "tipe": "text",
  "media_url": null,
  "reply_to": null,
  "rt_id": "rt05_rw05",
  "created_at": "2026-04-28T10:00:00Z"
}
```

| Field | Type | Description |
|-------|------|-------------|
| tipe | enum | `text`, `image`, `system` |
| reply_to | string? | ID pesan yang di-reply |

---

### 2.5 `announcements` — Pengumuman RT

```json
{
  "id": "auto_generated_id",
  "admin_id": "firebase_auth_uid",
  "nama_admin": "Pak RT Hasan",
  "judul": "Jadwal Kerja Bakti",
  "konten": "Kerja bakti akan dilaksanakan hari Minggu...",
  "foto_url": "https://...",
  "is_pinned": false,
  "rt_id": "rt05_rw05",
  "created_at": "2026-04-28T10:00:00Z"
}
```

---

### 2.6 `kontrakan` — Data Kontrakan

```json
{
  "id": "auto_generated_id",
  "nomor_rumah": "RT05-K03",
  "pemilik": "Pak Budi",
  "no_hp_pemilik": "081234567890",
  "status": "terisi",
  "penghuni": "Ahmad (kontrak)",
  "harga_per_bulan": 1500000,
  "rt_id": "rt05_rw05",
  "updated_at": "2026-04-28T10:00:00Z"
}
```

---

### 2.7 `keuangan` — Iuran & Keuangan

```json
{
  "id": "auto_generated_id",
  "user_id": "firebase_auth_uid",
  "nama_warga": "Ahmad Fauzi",
  "nomor_rumah": "RT05-012",
  "jenis": "iuran_kematian",
  "nominal": 10000,
  "status": "lunas",
  "periode": "2026-04",
  "metode_bayar": "transfer",
  "bukti_transfer_url": "https://...",
  "verified_by": null,
  "rt_id": "rt05_rw05",
  "created_at": "2026-04-28T10:00:00Z"
}
```

| Field | Description |
|-------|-------------|
| jenis | `iuran_kematian` (bulanan), `infak_mesjid` (mingguan) |
| status | `belum_bayar` → `menunggu_verifikasi` → `lunas` |
| metode_bayar | `tunai`, `transfer` |

---

### 2.8 `umkm` — Usaha Warga

```json
{
  "id": "auto_generated_id",
  "user_id": "firebase_auth_uid",
  "nama_usaha": "Warung Bu Siti",
  "jenis_usaha": "makanan",
  "deskripsi": "Warung nasi, gorengan, dan minuman",
  "nomor_rumah": "RT05-008",
  "jam_operasional": "06:00 - 21:00",
  "no_hp": "081234567890",
  "foto_url": "https://...",
  "is_active": true,
  "rt_id": "rt05_rw05"
}
```

---

### 2.9 `buku_tamu` — Lapor Tamu

```json
{
  "id": "auto_generated_id",
  "warga_id": "firebase_auth_uid",
  "nama_warga": "Ahmad Fauzi",
  "nomor_rumah": "RT05-012",
  "nama_tamu": "Bambang Suryadi",
  "asal_tamu": "Bandung",
  "tujuan": "Berkunjung keluarga",
  "no_ktp_tamu": "32xxxxxxxxxxxxxx",
  "check_in": "2026-04-28T10:00:00Z",
  "check_out": null,
  "rt_id": "rt05_rw05"
}
```

---

### 2.10 `anak_yatim` — Data Anak Yatim

```json
{
  "id": "auto_generated_id",
  "nama": "Dina Amelia",
  "tanggal_lahir": "2015-03-15",
  "jenis_kelamin": "perempuan",
  "nomor_rumah": "RT05-021",
  "nama_wali": "Ibu Sari",
  "pendidikan": "SD Kelas 5",
  "keterangan": "Yatim piatu",
  "rt_id": "rt05_rw05"
}
```

---

## 3. Indexing Strategy

### Composite Indexes (Firestore)

```
Collection: reports
  - [rt_id ASC, created_at DESC]     → List reports by RT, newest first
  - [rt_id ASC, status ASC]          → Filter by status within RT

Collection: emergencies
  - [rt_id ASC, is_active DESC, created_at DESC]  → Active emergencies first

Collection: discussions
  - [rt_id ASC, created_at ASC]      → Chat order

Collection: keuangan
  - [rt_id ASC, user_id ASC, periode DESC]   → User payment history
  - [rt_id ASC, jenis ASC, status ASC]       → Arrears report

Collection: announcements
  - [rt_id ASC, is_pinned DESC, created_at DESC]  → Pinned first
```

---

## 4. Data Relationships

```
users ──1:N──► reports        (warga buat banyak laporan)
users ──1:N──► emergencies    (warga trigger banyak SOS)
users ──1:N──► discussions    (warga kirim banyak pesan)
users ──1:N──► keuangan       (warga punya banyak pembayaran)
users ──1:1──► umkm           (warga punya 1 usaha)
users ──1:N──► buku_tamu      (warga lapor banyak tamu)
```

> **Catatan**: Firestore adalah NoSQL, jadi kita **denormalize** data (simpan `nama_pelapor` langsung di `reports` alih-alih join). Ini trade-off: sedikit data duplikat tapi query jauh lebih cepat.

---

## 5. Data Retention & Cleanup

| Collection | Retention | Reason |
|-----------|-----------|--------|
| users | Permanent | Data warga |
| reports | 1 year | Arsip laporan |
| emergencies | Permanent | Bukti & analisis keamanan |
| discussions | 6 months | Chat history |
| keuangan | Permanent | Audit trail keuangan |
| announcements | 1 year | Arsip pengumuman |

---

## 6. Backup Strategy

| Method | Frequency | Storage |
|--------|-----------|---------|
| Firestore Export | Weekly | Cloud Storage bucket |
| Manual Export | Monthly | Local backup (admin) |
