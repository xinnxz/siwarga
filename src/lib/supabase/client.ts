import { createBrowserClient } from "@supabase/ssr";

/**
 * Supabase Client (Browser)
 *
 * Untuk digunakan di Client Components ('use client').
 * Menggunakan anon key — akses dibatasi oleh Row-Level Security.
 */
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
