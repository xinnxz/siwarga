import { redirect } from "next/navigation";

/**
 * Root page — redirect ke dashboard kalau sudah login,
 * atau ke login kalau belum. Untuk sekarang langsung ke /dashboard
 * sebagai preview design system.
 */
export default function Home() {
  redirect("/dashboard");
}
