import { PrismaClient } from "@prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

/**
 * Prisma Client Singleton (Prisma v7 + Next.js 16)
 *
 * Prisma v7 BREAKING CHANGE:
 * - Engine type berubah dari "binary" menjadi "client"
 * - Dengan engine "client", wajib menggunakan Driver Adapter atau Accelerate
 * - Kita menggunakan @prisma/adapter-pg (Driver Adapter untuk PostgreSQL/Supabase)
 *
 * Flow koneksi:
 * DATABASE_URL (env) → pg Pool → PrismaPg adapter → PrismaClient
 *
 * Pattern singleton mencegah multiple connections saat dev hot-reload.
 */
function createPrismaClient() {
  const connectionString = process.env.DATABASE_URL;

  if (!connectionString) {
    throw new Error(
      "DATABASE_URL environment variable is not set. Check .env file."
    );
  }

  const adapter = new PrismaPg({ connectionString });
  return new PrismaClient({ adapter });
}

export const prisma = globalForPrisma.prisma ?? createPrismaClient();

if (process.env.NODE_ENV !== "production") {
  globalForPrisma.prisma = prisma;
}

export default prisma;
