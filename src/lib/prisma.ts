import { PrismaClient } from "@prisma/client";

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

/**
 * Prisma Client Singleton (Prisma v7 + Next.js 16)
 *
 * Prisma v7 runtime membaca DATABASE_URL dari environment variables
 * secara otomatis (via process.env). URL tidak perlu di-pass manual
 * ke constructor — cukup pastikan DATABASE_URL ada di .env.local
 *
 * Pattern singleton mencegah multiple connections saat dev hot-reload.
 */
export const prisma = globalForPrisma.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== "production") {
  globalForPrisma.prisma = prisma;
}

export default prisma;
