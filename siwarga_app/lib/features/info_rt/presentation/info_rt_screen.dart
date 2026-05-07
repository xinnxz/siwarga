import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

class InfoRtScreen extends ConsumerWidget {
  const InfoRtScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream =
        FirebaseFirestore.instance.collection(FirestorePaths.infoRt()).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Info RT'),
        actions: [
          if (admin)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: () => InfoRtScreen._upload(context),
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
              .toList()
            ..sort((a, b) {
              final ta = a.data()['created_at'];
              final tb = b.data()['created_at'];
              if (ta is Timestamp && tb is Timestamp) {
                return tb.compareTo(ta);
              }
              return 0;
            });
          if (docs.isEmpty) {
            return const EmptyState(message: 'Belum ada info.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final url = d['image_url'] as String?;
              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['judul'] as String? ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (url != null && url.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Future<void> _upload(BuildContext context) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x == null) return;
    final judulController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Judul info'),
        content: TextField(
          controller: judulController,
          decoration: const InputDecoration(hintText: 'Judul'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final judul = judulController.text.trim();
              if (judul.isEmpty) return;
              final refStorage = FirebaseStorage.instance
                  .ref()
                  .child('info_rt/${DateTime.now().millisecondsSinceEpoch}.jpg');
              await refStorage.putData(await x.readAsBytes());
              final url = await refStorage.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection(FirestorePaths.infoRt())
                  .add({
                'judul': judul,
                'image_url': url,
                'rt_id': AppConstants.rtId,
                'created_at': FieldValue.serverTimestamp(),
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
