import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../auth/application/auth_providers.dart';

class PatrolScreen extends ConsumerWidget {
  const PatrolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.patrolSchedule())
        .where('rt_id', isEqualTo: AppConstants.rtId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Ronda')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs.toList()
            ..sort((a, b) => (a.data()['hari'] as String? ?? '')
                .compareTo(b.data()['hari'] as String? ?? ''));
          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  admin
                      ? 'Belum ada jadwal. Tambah dokumen di patrol_schedule.'
                      : 'Jadwal belum diatur.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              return Card(
                child: ListTile(
                  title: Text(d['hari'] as String? ?? ''),
                  subtitle: Text(d['petugas'] as String? ?? ''),
                  trailing: admin
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final petugas = TextEditingController(
                              text: d['petugas'] as String? ?? '',
                            );
                            await showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Edit ${d['hari']}'),
                                content: TextField(
                                  controller: petugas,
                                  decoration: const InputDecoration(
                                    labelText: 'Petugas',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Batal'),
                                  ),
                                  FilledButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .doc(
                                        '${FirestorePaths.patrolSchedule()}/${docs[i].id}',
                                      )
                                          .update({
                                        'petugas': petugas.text.trim(),
                                        'updated_at':
                                            FieldValue.serverTimestamp(),
                                      });
                                      if (ctx.mounted) Navigator.pop(ctx);
                                    },
                                    child: const Text('Simpan'),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
