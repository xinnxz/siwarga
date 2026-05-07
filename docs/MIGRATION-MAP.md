# Sheet → Firestore Migration Map (RT 05 Digital → SiWarga)

Mapping kolom Google Sheets (legacy `kode.gs`) ke koleksi Firestore ([docs/architecture/02-database-design.md](architecture/02-database-design.md)).

**Konstanta:** `rt_id` = `rt05_rw05` (sesuaikan di produksi).

---

## Akun → Authentication + `users`

| Sheet column | Index | Firestore / Auth |
|--------------|-------|------------------|
| User | 0 | Gunakan sebagai **email login** (normalisasi: `username@siwarga.rt05.local` atau email sungguhan saat registrasi ulang) |
| Pass | 1 | **Jangan** impor plaintext — buat user via Admin SDK + paksa reset password / invite email |
| Nama | 2 | `users.nama` |
| Peran | 3 | Map: mengandung `Ketua` atau `Pengurus` → `role: admin`; lainnya → `role: warga` |
| NoRumah | 4 | `users.nomor_rumah` (string) |

---

## DataWarga → `users` / atau sub-collection opsional `citizens_legacy`

Di app Flutter, profil warga bisa satu dokumen `users` per UID. Data sheet tanpa UID awalnya: mapping oleh admin atau email.

| Sheet column | Index | Firestore |
|--------------|-------|-----------|
| Nama | 0 | `nama` |
| No Rumah | 1 | `nomor_rumah` |
| No HP | 2 | `no_hp` |
| Status | 3 | `housing_status` (`milik_sendiri` / `kontrakan`) |

---

## Pengumuman → `announcements`

| Sheet (fetch order) | Index | Firestore |
|---------------------|-------|-----------|
| Tanggal | 0 | `created_at` (parse dari string dd/MM/yyyy HH:mm) |
| Isi | 1 | `konten` |
| Nama pengirim | 2 | `nama_admin` |

Tambahkan: `judul` dari slice pertama isi (opsional), `rt_id`, `admin_id` null sampai di-link ke UID.

---

## Laporan → `reports`

| Sheet | Index | Firestore |
|-------|-------|-----------|
| Tanggal | 0 | `created_at` |
| Nama | 1 | `nama_pelapor` |
| Peran | 2 | simpan di `metadata.peran` atau abaikan |
| Isi | 3 | `isi_laporan` |
| Status | 4 | Map: `Proses`→`pending`, `Selesai`→`selesai`, `Ditolak`→`ditolak` |

---

## Chat → `discussions`

| Sheet | Index | Firestore |
|-------|-------|-----------|
| Tanggal | 0 | `created_at` |
| Nama | 1 | `nama_pengirim` |
| No Rumah | 2 | `nomor_rumah` |
| Pesan | 3 | `pesan`, `tipe: text` |

---

## BukuTamu → `buku_tamu`

Sesuaikan dengan index yang dipakai UI (`refreshTamu` di index.html: r[2]=nama tamu, r[4]=keperluan).

| Field UI | Firestore |
|----------|-----------|
| Pelapor | `nama_warga`, `warga_id` setelah match UID |
| Nama tamu | `nama_tamu` |
| Keperluan | `tujuan` |

---

## UangKematian → `keuangan` (aggregat) + opsional `finance_ledger`

Sheet menyimpan baris kas dengan saldo berjalan.

| Kolom | Firestore |
|-------|-----------|
| Tgl, Masuk, Keluar, Saldo, Ket | `jenis`, `nominal`, saldo snapshot di dokumen terpisah atau field |

Untuk Phase 2 parity: bisa satu koleksi `finance_transactions` mirror baris sheet.

---

## UMKM → `umkm`

| Sheet | Firestore |
|-------|-----------|
| Nama usaha | `nama_usaha` |
| Pemilik | map dari nama → `user_id` jika ada |
| No Rumah | `nomor_rumah` |
| Ket | `deskripsi` |

---

## DataYatim → `anak_yatim`

| Sheet | Firestore |
|-------|-----------|
| Nama | `nama` |
| Umur | `umur` atau hitung dari DOB jika nanti dilengkapi |
| No Rumah | `nomor_rumah` |

---

## Kontrakan → `kontrakan`

| Sheet | Firestore |
|-------|-----------|
| No rumah | `nomor_rumah` |
| Status | `status`: Kosong→`kosong`, Berpenghuni→`terisi` |

---

## JadwalRonda → `patrol_schedule` (custom) atau dokumen `rt_settings/ronda`

Format sheet bisa baris (hari, petugas) atau kolom header hari. Normalisasi ke array `{ day, officers[] }`.

---

## InfoRT → `announcements` dengan lampiran atau koleksi `info_rt_posts`

| Sheet | Firestore |
|-------|-----------|
| Tanggal | `created_at` |
| Judul | `judul` |
| Gambar Base64 | Upload ke Storage → `foto_url` |

---

## Sheet tidak ada di export default

Tambahkan di `exportAllSheetsToJson` jika ada sheet lain di spreadsheet aktif.
