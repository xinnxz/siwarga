export const dynamic = "force-dynamic";

import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { createServerClient } from "@/lib/supabase/server";
import { sanitize } from "@/lib/utils";

/**
 * POST /api/auth/register
 * Body: { inviteCode, name, houseNumber, phone?, username, password }
 *
 * Flow:
 * 1. Validasi invite code (ada, belum expired, belum max uses)
 * 2. Verifikasi houseNumber ada di tabel residents
 * 3. Buat akun via Supabase Auth (password di-hash otomatis)
 * 4. Simpan profil ke tabel users
 * 5. Update invite code used_count
 */
export async function POST(request: Request) {
  try {
    const body = await request.json();
    const inviteCode = sanitize(String(body.inviteCode ?? "").trim().toUpperCase());
    const name = sanitize(String(body.name ?? "").trim());
    const houseNumber = sanitize(String(body.houseNumber ?? "").trim());
    const phone = sanitize(String(body.phone ?? "").trim());
    const username = sanitize(String(body.username ?? "").trim().toLowerCase());
    const password = String(body.password ?? "");

    // ── Validasi input ──
    if (!inviteCode || !name || !houseNumber || !username || !password) {
      return NextResponse.json({ error: "Semua field wajib diisi" }, { status: 400 });
    }
    if (password.length < 8) {
      return NextResponse.json({ error: "Password minimal 8 karakter" }, { status: 400 });
    }

    // ── Step 1: Validate invite code ──
    const invite = await prisma.inviteCode.findUnique({
      where: { code: inviteCode },
    });

    if (!invite) {
      return NextResponse.json({ error: "Kode undangan tidak valid" }, { status: 400 });
    }
    if (!invite.isActive) {
      return NextResponse.json({ error: "Kode undangan sudah tidak aktif" }, { status: 400 });
    }
    if (new Date() > invite.expiresAt) {
      return NextResponse.json({ error: "Kode undangan sudah kadaluarsa" }, { status: 400 });
    }
    if (invite.usedCount >= invite.maxUses) {
      return NextResponse.json({ error: "Kode undangan sudah mencapai batas penggunaan" }, { status: 400 });
    }

    // ── Step 2: Verify house number ──
    const resident = await prisma.resident.findFirst({
      where: { houseNumber: { equals: houseNumber, mode: "insensitive" } },
    });

    if (!resident) {
      return NextResponse.json(
        { error: "Nomor rumah tidak ditemukan dalam data warga RT 05" },
        { status: 400 }
      );
    }

    // ── Step 3: Check username not taken ──
    const email = `${username}@siwarga.local`;
    const existing = await prisma.user.findFirst({ where: { email } });
    if (existing) {
      return NextResponse.json({ error: "Username sudah digunakan" }, { status: 400 });
    }

    // ── Step 4: Create Supabase Auth account ──
    const supabase = createServerClient();
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true, // Auto-confirm since we verify via invite code
    });

    if (authError || !authData.user) {
      console.error("[REGISTER AUTH ERROR]", authError);
      return NextResponse.json({ error: "Gagal membuat akun. Coba lagi." }, { status: 500 });
    }

    // ── Step 5: Save user profile ──
    const user = await prisma.user.create({
      data: {
        id: authData.user.id,
        email,
        name,
        houseNumber,
        phone: phone || null,
        password: "[managed-by-supabase]", // Never store plaintext
        role: "WARGA",
        inviteCodesUsed: {
          connect: { code: inviteCode },
        },
      },
    });

    // ── Step 6: Increment invite code usage ──
    await prisma.inviteCode.update({
      where: { code: inviteCode },
      data: {
        usedCount: { increment: 1 },
        usedBy: user.id,
      },
    });

    return NextResponse.json({
      data: {
        message: "Akun berhasil dibuat! Silakan login.",
        userId: user.id,
      },
    });
  } catch (err) {
    console.error("[REGISTER ERROR]", err);
    return NextResponse.json(
      { error: "Terjadi kesalahan server. Coba lagi." },
      { status: 500 }
    );
  }
}
