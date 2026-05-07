import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

class UmkmScreen extends ConsumerWidget {
  const UmkmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream =
        FirebaseFirestore.instance.collection(FirestorePaths.umkm()).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('UMKM RT'),
        actions: [
          if (admin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => UmkmScreen._edit(context, null, null),
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
            return const EmptyState(message: 'Belum ada UMKM.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              return AppCard(
                onTap: admin ? () => UmkmScreen._edit(context, docs[i].id, d) : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['nama_usaha'] as String? ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Pemilik: ${d['nama_pemilik'] ?? '-'} · ${d['nomor_rumah'] ?? '-'}',
                    ),
                    Text(d['deskripsi'] as String? ?? ''),
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
    final nama = TextEditingController(text: d?['nama_usaha'] as String?);
    final pemilik =
        TextEditingController(text: d?['nama_pemilik'] as String? ?? d?['pemilik'] as String?);
    final rumah =
        TextEditingController(text: d?['nomor_rumah'] as String? ?? '');
    final ket =
        TextEditingController(text: d?['deskripsi'] as String? ?? d?['ket'] as String?);

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
              decoration: const InputDecoration(labelText: 'Nama usaha'),
            ),
            TextField(
              controller: pemilik,
              decoration: const InputDecoration(labelText: 'Pemilik'),
            ),
            TextField(
              controller: rumah,
              decoration: const InputDecoration(labelText: 'No rumah'),
            ),
            TextField(
              controller: ket,
              decoration: const InputDecoration(labelText: 'Keterangan'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final col =
                    FirebaseFirestore.instance.collection(FirestorePaths.umkm());
                final payload = {
                  'nama_usaha': nama.text.trim(),
                  'nama_pemilik': pemilik.text.trim(),
                  'nomor_rumah': rumah.text.trim(),
                  'deskripsi': ket.text.trim(),
                  'rt_id': AppConstants.rtId,
                  'is_active': true,
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
