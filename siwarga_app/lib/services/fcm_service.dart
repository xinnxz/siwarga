import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Stub layanan FCM — lengkapi dengan subscribe topic, handler foreground,
/// dan simpan token ke `users/{uid}` setelah login.
class FcmService {
  FcmService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    // TODO: simpan token ke Firestore profil + subscribe rt05_all / rt05_pengurus
    if (token != null) {
      debugPrint('FCM token prefix: ${token.substring(0, 12)}…');
    }
  }
}
