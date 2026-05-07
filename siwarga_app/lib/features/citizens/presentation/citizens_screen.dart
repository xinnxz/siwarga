import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

class CitizensScreen extends ConsumerWidget {
  const CitizensScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.citizens())
        .where('rt_id', isEqualTo: AppConstants.rtId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Warga'),
        actions: [
          if (admin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => CitizensScreen._openEdit(context, ref, null),
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs.toList()
            ..sort((a, b) => (a.data()['nama'] as String? ?? '')
                .compareTo(b.data()['nama'] as String? ?? ''));
          if (docs.isEmpty) {
            return const EmptyState(message: 'Belum ada data warga.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              return AppCard(
                onTap: admin
                    ? () => CitizensScreen._openEdit(
                          context,
                          ref,
                          docs[i].id,
                          existing: d,
                        )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['nama'] as String? ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'No. ${d['nomor_rumah'] ?? '-'} · ${d['no_hp'] ?? '-'}',
                    ),
                    Text(d['status_rumah'] as String? ?? ''),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref,
    String? id, {
    Map<String, dynamic>? existing,
  }) async {
    final nama = TextEditingController(text: existing?['nama'] as String?);
    final rumah =
        TextEditingController(text: existing?['nomor_rumah'] as String?);
    final hp = TextEditingController(text: existing?['no_hp'] as String?);
    var status = (existing?['status_rumah'] as String?) ?? 'Milik Sendiri';

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
                controller: nama,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: rumah,
                decoration: const InputDecoration(labelText: 'No rumah'),
              ),
              TextField(
                controller: hp,
                decoration: const InputDecoration(labelText: 'No HP'),
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(
                    value: 'Milik Sendiri',
                    child: Text('Milik Sendiri'),
                  ),
                  DropdownMenuItem(
                    value: 'Kontrakan',
                    child: Text('Kontrakan'),
                  ),
                ],
                onChanged: (v) => setSt(() => status = v ?? status),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final col = FirebaseFirestore.instance
                      .collection(FirestorePaths.citizens());
                  final payload = {
                    'nama': nama.text.trim(),
                    'nomor_rumah': rumah.text.trim(),
                    'no_hp': hp.text.trim(),
                    'status_rumah': status,
                    'rt_id': AppConstants.rtId,
                    'updated_at': FieldValue.serverTimestamp(),
                  };
                  if (id == null) {
                    payload['created_at'] = FieldValue.serverTimestamp();
                    await col.add(payload);
                  } else {
                    await col.doc(id).set(payload, SetOptions(merge: true));
                  }
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(id == null ? 'Simpan' : 'Perbarui'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
