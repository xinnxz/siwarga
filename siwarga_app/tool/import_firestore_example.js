/**
 * Contoh impor JSON export Sheets → Firestore (Node.js + firebase-admin).
 *
 * Prasyarat:
 *   npm install firebase-admin
 *   Letakkan service account sebagai service-account.json (JANGAN commit).
 *   Letakkan siwarga_export.json hasil export GAS di folder yang sama.
 *
 * Sesuaikan pemetaan kolom dengan docs/MIGRATION-MAP.md di repo root.
 */
const fs = require('fs');
const admin = require('firebase-admin');

const serviceAccount = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function main() {
  const raw = fs.readFileSync('./siwarga_export.json', 'utf8');
  const data = JSON.parse(raw);

  // Contoh: tulis baris DataWarga (tanpa header) ke koleksi `citizens`
  const rows = data.DataWarga || [];
  if (rows.length < 2) {
    console.log('Tidak ada baris DataWarga.');
    return;
  }
  const header = rows[0];
  console.log('Header:', header);

  const batch = db.batch();
  for (let i = 1; i < rows.length; i++) {
    const r = rows[i];
    if (!r[0]) continue;
    const ref = db.collection('citizens').doc();
    batch.set(ref, {
      nama: String(r[0] ?? ''),
      nomor_rumah: String(r[1] ?? ''),
      no_hp: String(r[2] ?? ''),
      status_rumah: String(r[3] ?? ''),
      rt_id: 'rt05_rw05',
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();
  console.log('Selesai impor citizens.');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
