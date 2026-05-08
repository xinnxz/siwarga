export const dynamic = "force-dynamic";

import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { createServerClient } from "@/lib/supabase/server";
import { sanitize } from "@/lib/utils";

/**
 * POST /api/auth/login
 * Body: { username: string, password: string }
 */
export async function POST(request: Request) {
  try {
    const body = await request.json();
    const username = sanitize(String(body.username ?? "").trim());
    const password = String(body.password ?? "");

    if (!username || !password) {
      return NextResponse.json(
        { error: "Username dan password wajib diisi" },
        { status: 400 }
      );
    }

    // Find user by username (stored as email: username@siwarga.local)
    const email = `${username}@siwarga.local`;
    const supabase = createServerClient();

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error || !data.user) {
      return NextResponse.json(
        { error: "Username atau password salah" },
        { status: 401 }
      );
    }

    // Get user profile from database
    const user = await prisma.user.findFirst({
      where: { email },
      select: {
        id: true,
        name: true,
        role: true,
        houseNumber: true,
        isActive: true,
      },
    });

    if (!user) {
      return NextResponse.json(
        { error: "Akun tidak ditemukan" },
        { status: 404 }
      );
    }

    if (!user.isActive) {
      return NextResponse.json(
        { error: "Akun Anda telah dinonaktifkan. Hubungi pengurus RT." },
        { status: 403 }
      );
    }

    return NextResponse.json({
      data: {
        session: data.session,
        user: {
          id: user.id,
          name: user.name,
          role: user.role,
          houseNumber: user.houseNumber,
        },
      },
    });
  } catch (err) {
    console.error("[LOGIN ERROR]", err);
    return NextResponse.json(
      { error: "Terjadi kesalahan server. Coba lagi." },
      { status: 500 }
    );
  }
}
