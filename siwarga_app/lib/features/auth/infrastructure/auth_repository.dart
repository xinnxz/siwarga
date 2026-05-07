import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../domain/user_profile.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  /// Register user + dokumen profil. Hanya panggil dari UI yang sudah diverifikasi admin / bootstrap.
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String nama,
    required String role,
    String? nomorRumah,
    String? noHp,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = cred.user!.uid;
    await _firestore.doc(FirestorePaths.userDoc(uid)).set({
      'nama': nama,
      'email': email.trim(),
      'role': role,
      'nomor_rumah': nomorRumah,
      'no_hp': noHp,
      'rt_id': AppConstants.rtId,
      'is_active': true,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    return cred;
  }

  Stream<UserProfile?> profileStream(String uid) {
    return _firestore.doc(FirestorePaths.userDoc(uid)).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromDoc(doc);
    });
  }

  Future<void> updateProfile({
    required String uid,
    String? nama,
    String? noHp,
    String? nomorRumah,
    String? fotoUrl,
  }) async {
    final map = <String, dynamic>{
      'updated_at': FieldValue.serverTimestamp(),
    };
    if (nama != null) map['nama'] = nama;
    if (noHp != null) map['no_hp'] = noHp;
    if (nomorRumah != null) map['nomor_rumah'] = nomorRumah;
    if (fotoUrl != null) map['foto_url'] = fotoUrl;
    await _firestore.doc(FirestorePaths.userDoc(uid)).update(map);
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw StateError('Tidak ada pengguna login.');
    }
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }
}
