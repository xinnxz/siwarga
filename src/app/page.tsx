import { redirect } from "next/navigation";

/**
 * Root page — middleware akan handle redirect:
 * - Belum login → /login
 * - Sudah login → /dashboard
 */
export default function Home() {
  redirect("/login");
}
