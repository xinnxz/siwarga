import { PrismaClient } from "@prisma/client";

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

/**
 * Prisma Client Singleton
 *
 * Mencegah multiple instance PrismaClient saat Next.js hot-reload
 * di development mode. Di production, hanya satu instance yang dibuat.
 *
 * @see https://www.prisma.io/docs/guides/nextjs
 */
export const prisma = globalForPrisma.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;

export default prisma;
