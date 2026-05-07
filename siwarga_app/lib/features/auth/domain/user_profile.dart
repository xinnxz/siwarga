import 'package:cloud_firestore/cloud_firestore.dart';

/// Profil pengguna — dokumen `users/{uid}`.
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.nama,
    required this.email,
    required this.role,
    this.nomorRumah,
    this.noHp,
    this.fotoUrl,
    this.rtId,
    this.fcmTopics,
  });

  final String uid;
  final String nama;
  final String email;
  final String role;
  final String? nomorRumah;
  final String? noHp;
  final String? fotoUrl;
  final String? rtId;
  final List<String>? fcmTopics;

  bool get isAdmin {
    final r = role.toLowerCase();
    return r == 'admin' ||
        r == 'super_admin' ||
        r.contains('admin') ||
        r.contains('ketua') ||
        r.contains('pengurus');
  }

  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    if (d == null) {
      return UserProfile(
        uid: doc.id,
        nama: '',
        email: '',
        role: 'warga',
      );
    }
    return UserProfile(
      uid: doc.id,
      nama: d['nama'] as String? ?? '',
      email: d['email'] as String? ?? '',
      role: d['role'] as String? ?? 'warga',
      nomorRumah: d['nomor_rumah'] as String?,
      noHp: d['no_hp'] as String?,
      fotoUrl: d['foto_url'] as String?,
      rtId: d['rt_id'] as String?,
      fcmTopics: (d['fcm_topics'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toWrite() => {
        'nama': nama,
        'email': email,
        'role': role,
        if (nomorRumah != null) 'nomor_rumah': nomorRumah,
        if (noHp != null) 'no_hp': noHp,
        if (fotoUrl != null) 'foto_url': fotoUrl,
        if (rtId != null) 'rt_id': rtId,
      };
}
