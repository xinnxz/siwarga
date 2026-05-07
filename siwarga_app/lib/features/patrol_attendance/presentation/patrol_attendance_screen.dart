import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/application/auth_providers.dart';

class PatrolAttendanceScreen extends ConsumerWidget {
  const PatrolAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.patrolAttendance())
        .orderBy('check_in', descending: true)
        .limit(80)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Presensi Ronda')),
      floatingActionButton: user != null
          ? FloatingActionButton.extended(
              onPressed: () => PatrolAttendanceScreen._checkIn(
                    context,
                    user.uid,
                    profile?.nama ?? '',
                  ),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Hadir'),
            )
          : null,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs
              .where((doc) =>
                  (doc.data()['rt_id'] as String?) == AppConstants.rtId ||
                  doc.data()['rt_id'] == null)
              .toList();
          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada presensi.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final ts = d['check_in'];
              var when = '';
              if (ts is Timestamp) {
                when = ts.toDate().toLocal().toString().substring(0, 16);
              }
              return AppCard(
                child: ListTile(
                  title: Text(d['nama'] as String? ?? ''),
                  subtitle: Text(when),
                  trailing: (d['photo_url'] as String?) != null
                      ? const Icon(Icons.photo_camera_outlined)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Future<void> _checkIn(
    BuildContext context,
    String uid,
    String nama,
  ) async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (x == null) return;

    final refImg = FirebaseStorage.instance
        .ref()
        .child('patrol_attendance/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await refImg.putData(await x.readAsBytes());
    final url = await refImg.getDownloadURL();

    await FirebaseFirestore.instance
        .collection(FirestorePaths.patrolAttendance())
        .add({
      'user_id': uid,
      'nama': nama,
      'photo_url': url,
      'check_in': FieldValue.serverTimestamp(),
      'rt_id': AppConstants.rtId,
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presensi tercatat.')),
      );
    }
  }
}
