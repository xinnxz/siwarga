import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../auth/application/auth_providers.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream =
        FirebaseFirestore.instance.collection(FirestorePaths.gallery()).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri Kegiatan'),
        actions: [
          if (admin)
            IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              onPressed: () => GalleryScreen._upload(context),
            ),
        ],
      ),
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
            return const Center(child: Text('Belum ada foto.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final url = docs[i].data()['image_url'] as String? ?? '';
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Future<void> _upload(BuildContext context) async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x == null) return;
    final judul = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keterangan'),
        content: TextField(
          controller: judul,
          decoration: const InputDecoration(hintText: 'Judul / acara'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final refS = FirebaseStorage.instance
                  .ref()
                  .child('gallery/${DateTime.now().millisecondsSinceEpoch}.jpg');
              await refS.putData(await x.readAsBytes());
              final url = await refS.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection(FirestorePaths.gallery())
                  .add({
                'judul': judul.text.trim(),
                'image_url': url,
                'rt_id': AppConstants.rtId,
                'created_at': FieldValue.serverTimestamp(),
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Unggah'),
          ),
        ],
      ),
    );
  }
}
