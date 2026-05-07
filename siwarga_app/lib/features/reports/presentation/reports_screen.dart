import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final _isi = TextEditingController();
  final _judul = TextEditingController();

  Future<void> _kirim() async {
    final profile = ref.read(userProfileProvider).valueOrNull;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null || profile == null) return;
    if (_isi.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection(FirestorePaths.reports()).add({
      'user_id': user.uid,
      'nama_pelapor': profile.nama,
      'nomor_rumah': profile.nomorRumah ?? '',
      'judul': _judul.text.trim().isEmpty ? 'Laporan' : _judul.text.trim(),
      'isi_laporan': _isi.text.trim(),
      'kategori': 'lainnya',
      'status': 'pending',
      'rt_id': AppConstants.rtId,
      'created_at': FieldValue.serverTimestamp(),
    });
    _isi.clear();
    _judul.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan terkirim.')),
      );
    }
  }

  Future<void> _setStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .doc('${FirestorePaths.reports()}/$docId')
        .update({
      'status': status,
      'resolved_at': status == 'selesai'
          ? FieldValue.serverTimestamp()
          : null,
    });
  }

  @override
  void dispose() {
    _isi.dispose();
    _judul.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final admin = profile?.isAdmin ?? false;

    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.reports())
        .orderBy('created_at', descending: true)
        .limit(50)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Warga')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _judul,
                  label: 'Judul (opsional)',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _isi,
                  label: 'Isi laporan',
                  maxLines: 5,
                ),
                const SizedBox(height: 12),
                AppButton(label: 'KIRIM LAPORAN', onPressed: _kirim),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('${snap.error}'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs
                    .where((doc) =>
                        (doc.data()['rt_id'] as String?) == AppConstants.rtId ||
                        doc.data()['rt_id'] == null)
                    .toList();
                if (docs.isEmpty) {
                  return const EmptyState(message: 'Belum ada laporan.');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data();
                    final st = d['status'] as String? ?? 'pending';
                    return AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['judul'] as String? ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${d['nama_pelapor']} · ${d['nomor_rumah'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(d['isi_laporan'] as String? ?? ''),
                          const SizedBox(height: 8),
                          Chip(label: Text(st)),
                          if (admin) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _setStatus(docs[i].id, 'ditangani'),
                                  child: const Text('Proses'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      _setStatus(docs[i].id, 'selesai'),
                                  child: const Text('Selesai'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      _setStatus(docs[i].id, 'ditolak'),
                                  child: const Text('Tolak'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
