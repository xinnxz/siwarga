// ============================================================
// RT 05 DIGITAL - Kode.gs
// ============================================================
//
// FREEZE / READONLY (setelah cutover Flutter): Setelah migrasi ke Firebase
// selesai dan disetujui Ketua RT, nonaktifkan fungsi yang menulis ke sheet
// (saveData, deleteData, updateData, saveKas, dll.) atau hentikan deployment
// Web App ini agar sumber kebenaran tunggal ada di Firestore.
//

function doGet() {
  return HtmlService.createTemplateFromFile('index').evaluate()
    .setTitle('RT 05 Digital')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}

// LOGIN
function checkLogin(u, p) {
  try {
    var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Akun');
    var d = s.getDataRange().getValues();
    for (var i = 1; i < d.length; i++) {
      if (d[i][0].toString() == u && d[i][1].toString() == p) {
        var noRumah = (d[i].length > 4 && d[i][4] !== '' && d[i][4] !== undefined)
                      ? d[i][4].toString() : '-';
        return { success: true, nama: d[i][2].toString(), peran: d[i][3].toString(), noRumah: noRumah };
      }
    }
    return { success: false };
  } catch(e) {
    return { success: false, error: e.message };
  }
}

// FETCH DATA UNIVERSAL (Date ke String)
function fetchData(name) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(name);
  if (!s) return [];
  var d = s.getDataRange().getValues();
  if (d.length <= 1) return [];
  var tz = Session.getScriptTimeZone();
  return d.slice(1).map(function(row) {
    return row.map(function(cell) {
      if (cell instanceof Date) {
        return Utilities.formatDate(cell, tz, 'dd/MM/yyyy HH:mm');
      }
      return cell;
    });
  });
}

// FETCH RONDA
// Mendukung 2 format sheet JadwalRonda:
// Format LAMA: kolom A=Hari, kolom B=Petugas (per baris, ada header di baris 1)
// Format BARU: baris 1 = nama hari sebagai header kolom, baris 2 = isi petugas
function fetchRonda() {
  try {
    var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('JadwalRonda');
    if (!s || s.getLastRow() < 1) return [];
    var d = s.getDataRange().getValues();
    if (d.length === 0) return [];
    var firstCell = d[0][0] ? d[0][0].toString().trim().toLowerCase() : '';
    // Format lama: header baris 1 adalah "Hari" atau "Petugas"
    var isOldFormat = (firstCell === 'hari' || firstCell === 'day' || d[0].length === 2);
    if (isOldFormat) {
      var result = [];
      for (var i = 1; i < d.length; i++) {
        if (d[i][0]) result.push([d[i][0].toString(), (d[i][1]||'').toString()]);
      }
      return result;
    }
    // Format baru: baris 1 = nama hari sebagai kolom header
    var headers = d[0];
    var petugas = d.length > 1 ? d[1] : [];
    var result2 = [];
    for (var j = 0; j < headers.length; j++) {
      if (headers[j] && headers[j].toString().trim() !== '') {
        result2.push([headers[j].toString(), (petugas[j]||'').toString()]);
      }
    }
    return result2;
  } catch(e) {
    return [];
  }
}

// UPDATE RONDA berdasarkan nama hari (untuk format baru)
function updateRondaByHari(hari, petugasBaru) {
  try {
    var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('JadwalRonda');
    if (!s) return false;
    var d = s.getDataRange().getValues();
    if (d.length === 0) return false;
    var firstCell = d[0][0] ? d[0][0].toString().trim().toLowerCase() : '';
    var isOldFormat = (firstCell === 'hari' || firstCell === 'day' || d[0].length === 2);
    if (isOldFormat) {
      // Format lama: cari baris yang cocok
      for (var i = 1; i < d.length; i++) {
        if (d[i][0].toString().toLowerCase() === hari.toLowerCase()) {
          s.getRange(i + 1, 2).setValue(petugasBaru);
          return true;
        }
      }
      s.appendRow([hari, petugasBaru]);
      return true;
    }
    // Format baru: cari kolom yang cocok
    var headers = d[0];
    for (var j = 0; j < headers.length; j++) {
      if (headers[j].toString().toLowerCase() === hari.toLowerCase()) {
        if (s.getLastRow() < 2) {
          s.appendRow(new Array(headers.length).fill(''));
        }
        s.getRange(2, j + 1).setValue(petugasBaru);
        return true;
      }
    }
    return false;
  } catch(e) {
    return false;
  }
}

// SIMPAN DATA UNIVERSAL
function saveData(sheet, row) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheet);
  if (!s) return false;
  s.appendRow(row);
  return true;
}

// HAPUS DATA
function deleteData(sheet, rowNum) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheet);
  if (!s) return false;
  s.deleteRow(rowNum);
  return true;
}

// UPDATE/EDIT DATA
function updateData(sheet, rowNum, row) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheet);
  if (!s) return false;
  s.getRange(rowNum, 1, 1, row.length).setValues([row]);
  return true;
}

// UPDATE STATUS LAPORAN
function updateStatusLaporan(rowNum, status) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Laporan');
  if (!s) return false;
  s.getRange(rowNum, 5).setValue(status);
  return true;
}

// SIMPAN KAS / UANG KEMATIAN
function saveKas(j, n, k) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('UangKematian');
  var lr = s.getLastRow();
  var ls = lr > 1 ? s.getRange(lr, 4).getValue() : 0;
  var masuk = j == 'Masuk' ? Number(n) : 0;
  var keluar = j == 'Keluar' ? Number(n) : 0;
  var saldoBaru = Number(ls) + masuk - keluar;
  var tgl = Utilities.formatDate(new Date(), Session.getScriptTimeZone(), 'dd/MM/yyyy HH:mm');
  s.appendRow([tgl, masuk, keluar, saldoBaru, k]);
  return true;
}

// UPDATE KONTRAKAN
function updateKontrakan(no, st) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Kontrakan');
  var d = s.getDataRange().getValues();
  for (var i = 1; i < d.length; i++) {
    if (d[i][0].toString() == no) {
      s.getRange(i + 1, 2).setValue(st);
      return true;
    }
  }
  s.appendRow([no, st]);
  return true;
}

// SIMPAN INFO RT
function saveInfoRT(judul, imageData) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('InfoRT');
  if (!s) return false;
  var tgl = Utilities.formatDate(new Date(), Session.getScriptTimeZone(), 'dd/MM/yyyy HH:mm');
  s.appendRow([tgl, judul, imageData]);
  return true;
}

// SIMPAN CHAT
function saveChat(nama, noRumah, pesan) {
  var s = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Chat');
  if (!s) return false;
  var tgl = Utilities.formatDate(new Date(), Session.getScriptTimeZone(), 'dd/MM/yyyy HH:mm');
  s.appendRow([tgl, nama, noRumah, pesan]);
  return true;
}

// ============================================================
// EXPORT SEMUA SHEET → JSON DI GOOGLE DRIVE (untuk migrasi Firestore)
// Jalankan dari editor Apps Script: pilih fungsi exportAllSheetsToJson → Run
// ============================================================
function exportAllSheetsToJson() {
  var sheets = [
    'Akun', 'DataWarga', 'Pengumuman', 'Laporan', 'BukuTamu',
    'UangKematian', 'UMKM', 'DataYatim', 'Kontrakan',
    'JadwalRonda', 'InfoRT', 'Chat'
  ];
  var out = {};
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  sheets.forEach(function(name) {
    var sh = ss.getSheetByName(name);
    if (sh) {
      out[name] = sh.getDataRange().getValues();
    }
  });
  var stamp = new Date().getTime();
  var fileName = 'siwarga_export_' + stamp + '.json';
  DriveApp.createFile(fileName, JSON.stringify(out, null, 2), MimeType.PLAIN_TEXT);
}