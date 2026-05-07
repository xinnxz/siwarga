/// Path koleksi Firestore — selaras dengan docs/architecture/02-database-design.md
class FirestorePaths {
  FirestorePaths._();

  static String users() => 'users';
  static String userDoc(String uid) => 'users/$uid';

  static String reports() => 'reports';
  static String emergencies() => 'emergencies';
  static String discussions() => 'discussions';
  static String announcements() => 'announcements';
  static String kontrakan() => 'kontrakan';
  static String keuangan() => 'keuangan';
  static String umkm() => 'umkm';
  static String bukuTamu() => 'buku_tamu';
  static String anakYatim() => 'anak_yatim';
  static String patrolSchedule() => 'patrol_schedule';
  static String infoRt() => 'info_rt';
  static String agenda() => 'agenda';
  static String gallery() => 'gallery';
  static String duesPeriods() => 'dues_periods';
  static String patrolAttendance() => 'patrol_attendance';

  /// Tagihan / pembayaran per periode (Phase 3).
  static String duesPayments() => 'dues_payments';

  /// Direktori warga (mirror sheet DataWarga), terpisah dari akun login.
  static String citizens() => 'citizens';

  /// Buku kas harian (mirror UangKematian).
  static String financeLedger() => 'finance_ledger';
}
