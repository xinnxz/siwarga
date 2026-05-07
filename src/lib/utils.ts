/**
 * Format currency ke format Rupiah Indonesia
 * @example formatRupiah(1500000) → "Rp 1.500.000"
 */
export function formatRupiah(amount: number): string {
  return "Rp " + amount.toLocaleString("id-ID");
}

/**
 * Format tanggal ke format Indonesia
 * @example formatDate(new Date()) → "8 Mei 2026, 06:30"
 */
export function formatDate(date: Date | string): string {
  const d = typeof date === "string" ? new Date(date) : date;
  return d.toLocaleString("id-ID", {
    day: "numeric",
    month: "long",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

/**
 * Sanitize input string — strip HTML tags untuk prevent XSS
 */
export function sanitize(input: string): string {
  return input
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#x27;");
}

/**
 * Generate random invite code (6 karakter alfanumerik uppercase)
 * @example generateInviteCode() → "RT05AB"
 */
export function generateInviteCode(): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // no I/O/0/1 to avoid confusion
  let code = "RT";
  for (let i = 0; i < 4; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
}

/**
 * Truncate text ke max length dengan ellipsis
 */
export function truncate(text: string, maxLength: number = 100): string {
  if (text.length <= maxLength) return text;
  return text.slice(0, maxLength).trim() + "...";
}
