import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

/**
 * proxy.ts — Route Protection (Next.js 16)
 *
 * Menggantikan middleware.ts yang sudah deprecated di Next.js 16.
 * Fungsi harus bernama `proxy` (bukan `middleware`).
 *
 * Protected routes: semua halaman kecuali /login dan /register
 * Logic: cek cookie session dari Supabase Auth
 */

const PUBLIC_ROUTES = ["/login", "/register"];
const SKIP_PREFIXES = ["/_next", "/favicon.ico", "/icons", "/api/auth"];

export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Skip internal routes dan file statis
  if (SKIP_PREFIXES.some((prefix) => pathname.startsWith(prefix))) {
    return NextResponse.next();
  }

  // Cek session cookie Supabase (format: sb-<project_ref>-auth-token)
  const sessionCookie =
    request.cookies.get("sb-pwnnsicvhqufxbmetxoq-auth-token") ??
    request.cookies.get("supabase-auth-token");

  const isLoggedIn = !!sessionCookie?.value;
  const isPublicRoute = PUBLIC_ROUTES.some((route) => pathname === route);

  // Belum login dan bukan public route → redirect ke login
  if (!isLoggedIn && !isPublicRoute) {
    const loginUrl = new URL("/login", request.url);
    loginUrl.searchParams.set("redirect", pathname);
    return NextResponse.redirect(loginUrl);
  }

  // Sudah login dan akses public route → redirect ke dashboard
  if (isLoggedIn && isPublicRoute) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|icons).*)",
  ],
};
