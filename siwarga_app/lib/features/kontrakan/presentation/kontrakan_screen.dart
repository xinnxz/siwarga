import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

class KontrakanScreen extends ConsumerWidget {
  const KontrakanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream =
        FirebaseFirestore.instance.collection(FirestorePaths.kontrakan()).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontrakan'),
        actions: [
          if (admin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => KontrakanScreen._sheet(context, ref, null, null),
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
            return const EmptyState(message: 'Belum ada data kontrakan.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final kosong =
                  (d['status'] as String? ?? '').toLowerCase().contains('kosong');
              return AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'No. ${d['nomor_rumah'] ?? docs[i].id}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Chip(
                      label: Text(d['status'] as String? ?? '-'),
                      backgroundColor:
                          kosong ? Colors.green.shade100 : Colors.purple.shade50,
                    ),
                    if (admin)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => KontrakanScreen._sheet(
                          context,
                          ref,
                          docs[i].id,
                          d,
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

  static Future<void> _sheet(
    BuildContext context,
    WidgetRef ref,
    String? docId,
    Map<String, dynamic>? existing,
  ) async {
    final no =
        TextEditingController(text: existing?['nomor_rumah']?.toString() ?? '');
    var status = (existing?['status'] as String?) ?? 'Kosong';

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
        child: StatefulBuilder(
          builder: (context, setSt) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: no,
                decoration: const InputDecoration(labelText: 'No rumah'),
                enabled: docId == null,
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: 'Kosong', child: Text('Kosong')),
                  DropdownMenuItem(
                    value: 'Berpenghuni',
                    child: Text('Berpenghuni'),
                  ),
                ],
                onChanged: (v) => setSt(() => status = v ?? status),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final col = FirebaseFirestore.instance
                      .collection(FirestorePaths.kontrakan());
                  final payload = {
                    'nomor_rumah': no.text.trim(),
                    'status': status,
                    'rt_id': AppConstants.rtId,
                    'updated_at': FieldValue.serverTimestamp(),
                  };
                  if (docId == null) {
                    await col.add({
                      ...payload,
                      'created_at': FieldValue.serverTimestamp(),
                    });
                  } else {
                    await col.doc(docId).set(payload, SetOptions(merge: true));
                  }
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
