import { createClient as createSupabaseClient } from "@supabase/supabase-js";

/**
 * Supabase Admin Client (Server-side only)
 *
 * Menggunakan service_role key — BYPASS Row-Level Security.
 * JANGAN PERNAH expose ke browser/client.
 * Hanya untuk API routes dan server components.
 */
export function createServerClient() {
  return createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    }
  );
}
