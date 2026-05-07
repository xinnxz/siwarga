import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

class YatimScreen extends ConsumerWidget {
  const YatimScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.anakYatim())
        .where('rt_id', isEqualTo: AppConstants.rtId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Yatim'),
        actions: [
          if (admin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => YatimScreen._edit(context, null, null),
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const EmptyState(message: 'Belum ada data.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              return AppCard(
                onTap: admin
                    ? () => YatimScreen._edit(context, docs[i].id, d)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['nama'] as String? ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Umur: ${d['umur'] ?? '-'} · Rumah: ${d['nomor_rumah'] ?? '-'}',
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

  static Future<void> _edit(
    BuildContext context,
    String? id,
    Map<String, dynamic>? d,
  ) async {
    final nama = TextEditingController(text: d?['nama'] as String?);
    final umur = TextEditingController(text: d?['umur']?.toString() ?? '');
    final rumah =
        TextEditingController(text: d?['nomor_rumah'] as String? ?? '');

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nama,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: umur,
              decoration: const InputDecoration(labelText: 'Umur'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: rumah,
              decoration: const InputDecoration(labelText: 'No rumah'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final col = FirebaseFirestore.instance
                    .collection(FirestorePaths.anakYatim());
                final payload = {
                  'nama': nama.text.trim(),
                  'umur': umur.text.trim(),
                  'nomor_rumah': rumah.text.trim(),
                  'rt_id': AppConstants.rtId,
                  'updated_at': FieldValue.serverTimestamp(),
                };
                if (id == null) {
                  await col.add({
                    ...payload,
                    'created_at': FieldValue.serverTimestamp(),
                  });
                } else {
                  await col.doc(id).set(payload, SetOptions(merge: true));
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(id == null ? 'Simpan' : 'Update'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
