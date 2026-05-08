import { PrismaClient } from "@prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";
import { createClient } from "@supabase/supabase-js";
import "dotenv/config";

// Setup Supabase Admin Client
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error("Missing SUPABASE environment variables.");
  process.exit(1);
}

const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

// Setup Prisma with Adapter
const connectionString = process.env.DATABASE_URL!;
const adapter = new PrismaPg({ connectionString });
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log("🌱 Mulai melakukan seeding database...");

  const adminEmail = "pengurus@rt05.com";
  const adminPassword = "Password123!";

  // 1. Buat user di Supabase Auth
  console.log("Memeriksa User Supabase...");
  let authUser;

  // Cari apakah user sudah ada
  const { data: existingUsers, error: listError } = await supabaseAdmin.auth.admin.listUsers();

  if (listError) {
    console.error("Gagal mendapatkan list user Supabase:", listError);
    process.exit(1);
  }

  const existingAuthUser = existingUsers.users.find(u => u.email === adminEmail);

  if (existingAuthUser) {
    console.log("✅ User Pengurus sudah ada di Supabase Auth.");
    authUser = existingAuthUser;
  } else {
    console.log("⏳ Membuat User Pengurus di Supabase Auth...");
    const { data: newUser, error: createError } = await supabaseAdmin.auth.admin.createUser({
      email: adminEmail,
      password: adminPassword,
      email_confirm: true,
    });

    if (createError) {
      console.error("Gagal membuat user Supabase:", createError);
      process.exit(1);
    }

    authUser = newUser.user;
    console.log("✅ Berhasil membuat User Supabase Auth.");
  }

  // 2. Buat user di Prisma (Tabel User)
  console.log("Memeriksa User di database Prisma...");
  const existingDbUser = await prisma.user.findUnique({
    where: { id: authUser.id }
  });

  if (existingDbUser) {
    console.log("✅ User Pengurus sudah ada di database Prisma.");
  } else {
    console.log("⏳ Menyimpan User Pengurus ke database Prisma...");
    await prisma.user.create({
      data: {
        id: authUser.id,
        email: adminEmail,
        name: "Ketua RT 05",
        password: "hashed_by_supabase", // Supabase handle the real hash
        role: "PENGURUS",
        houseNumber: "A1",
        phone: "081234567890",
        isActive: true,
      }
    });
    console.log("✅ Berhasil menyimpan User Pengurus ke Prisma.");
  }

  // 3. Buat Kode Undangan Baru
  console.log("Membuat Kode Undangan (Invite Code)...");

  // Hapus kode undangan lama jika ada untuk admin ini
  await prisma.inviteCode.deleteMany({
    where: { createdBy: authUser.id }
  });

  // Generate random 5 chars code or use fixed
  const inviteCode = "RT05X";

  await prisma.inviteCode.create({
    data: {
      code: inviteCode,
      maxUses: 10,
      usedCount: 0,
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 hari dari sekarang
      createdBy: authUser.id,
    }
  });

  console.log("✅ Berhasil membuat Kode Undangan.");

  // 4. Buat data warga dummy (Resident) untuk verifikasi nomor rumah
  console.log("Memeriksa data Resident dummy...");
  const dummyHouse = "B2";
  const existingResident = await prisma.resident.findFirst({
    where: { houseNumber: dummyHouse }
  });

  if (!existingResident) {
    console.log("⏳ Membuat data Resident dummy...");
    await prisma.resident.create({
      data: {
        houseNumber: dummyHouse,
        name: "Bapak Warga Test",
        phone: "081234567891",
      }
    });
    console.log("✅ Berhasil membuat data Resident dummy.");
  } else {
    console.log("✅ Data Resident dummy sudah ada.");
  }

  console.log("\n=============================================");
  console.log("🎉 SEEDING SELESAI!");
  console.log("Kamu sekarang bisa menggunakan kredensial ini:");
  console.log("=============================================");
  console.log("👤 AKUN PENGURUS (Untuk Login):");
  console.log(`   Email    : ${adminEmail}`);
  console.log(`   Password : ${adminPassword}`);
  console.log("\n🎟️ KODE UNDANGAN (Untuk Register Warga Baru):");
  console.log(`   Kode     : ${inviteCode}`);
  console.log("=============================================\n");
}

main()
  .catch((e) => {
    console.error("❌ Seeding gagal:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
