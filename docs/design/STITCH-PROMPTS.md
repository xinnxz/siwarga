# Stitch Prompt Templates — SiWarga RT.05

Gunakan bersama [DESIGN-TOKENS.md](DESIGN-TOKENS.md). Output HTML/Tailwind dari Stitch **jangan** dipaste mentah ke production — konversi ke widget Flutter di `siwarga_app/lib/core/widgets/` dan `features/*/presentation/`.

---

## Global prefix (tambahkan ke setiap prompt)

```
Project: SiWarga RT.05 — aplikasi komunitas RT Indonesia (mobile-first).
Audience: warga usia 25–65, banyak HP Android layar 5.5–6.5 inch.
Language UI: Bahasa Indonesia, tone ramah dan jelas.
Brand colors: primary #1a237e, danger #c62828, background light #f0f2f8 / dark #0f1117.
Font: Poppins. Card radius 14px, pill buttons fully rounded.
Output: single-screen mobile HTML + Tailwind only, no desktop breakpoints.
```

---

## 1. Home / Beranda

```
Layar beranda: header gradient biru (#1a237e → #3949ab) dengan logo bundar, nama app "RT 05 DIGITAL",
nama pengguna dan badge no rumah. Di bawahnya grid 4 kolom menu ikon: Warga, Kontrakan, Info RT,
Yatim, Buku Tamu, Uang Kematian, UMKM, Ronda. Section "Pengumuman terkini" dengan kartu kiriman terbaru.
Bottom navigation 5 item: Home, Lapor, SOS (warna merah), Diskusi, Tentang.
```

---

## 2. SOS Darurat

```
Layar darurat: judul merah "DARURAT SOS". Teks penjelasan singkat. Tombol bulat besar merah dengan ikon
peringatan dan teks "DARURAT" (pulse shadow). Di bawah catatan kecil bahwa alert juga dikirim ke pengurus.
Prioritas UX: satu ketukan besar, kontras tinggi, dark mode friendly.
```

---

## 3. Iuran bulanan (warga)

```
[Lihat DESIGN-TOKENS] Layar "Iuran Bulanan": header dengan avatar. Kartu ringkasan bulan berjalan —
status LUNAS (hijau) atau BELUM BAYAR Rp … (merah). Daftar 6 bulan terakhir dengan pill status per bulan.
Tombol sticky bawah "Bayar Sekarang" jika ada tunggakan. Tambahkan area upload bukti transfer (preview thumbnail).
```

---

## 4. Dashboard Admin

```
Layar admin-only: grid statistik 2 kolom — Total Warga, Saldo Kas, Laporan Pending, SOS Aktif (24 jam),
Tunggakan Iuran. Kartu dengan angka besar dan ikon. Quick actions: "Tulis Pengumuman", "Tes Notifikasi".
```

---

## 5. Kalender Agenda RT

```
Kalender bulanan kompak + list agenda mendatang. Item: judul, tanggal range, lokasi, chip kategori
(Rapat / Kerja bakti / Keagamaan / Sosial). FAB "+" untuk admin (abaikan jika bukan admin).
```

---

## 6. Login & Profil

```
(A) Login: logo, field email & password, tombol utama Masuk, link Lupa password.
(B) Profil: foto bulat, nama, no HP, no rumah, toggle notifikasi per kategori, tombol Ubah password, Keluar.
```

---

## 7. Diskusi / Chat

```
Thread chat bubble: pesan sendiri kanan (biru #1a237e), pesan lain kiri abu/putih dengan nama dan no rumah.
Input area sticky bottom dengan TextArea dan tombol kirim bundar. Empty state ramah.
```

---

## 8. Pengumuman

```
Feed kartu vertikal: nama pengirim, tanggal, isi teks. Pin badge untuk pengumuman penting (opsional).
Admin: tombol tambah mengambang atau inline "+ Tulis".
```

---

## 9. Galeri kegiatan

```
Grid foto 3 kolom, tap untuk lightbox. Header judul "Galeri RT". Filter chip tahun atau event (optional).
```

---

## 10. Laporan warga

```
Form: textarea besar untuk isi laporan, tombol "KIRIM LAPORAN". Di bawah riwayat kartu dengan status
badge: Proses / Selesai / Ditolak warna berbeda. Opsional lampiran foto (thumbnail).
```

---

## Conversion checklist (Flutter)

1. Replace fixed px with theme spacing where possible.
2. Use `AppCard`, `AppButton`, `AppTextField` from `core/widgets`.
3. Verify light + dark + 3 font scales.
4. No secrets or API keys in Stitch output.
