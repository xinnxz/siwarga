import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

class GuestsScreen extends ConsumerStatefulWidget {
  const GuestsScreen({super.key});

  @override
  ConsumerState<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends ConsumerState<GuestsScreen> {
  final _nama = TextEditingController();
  final _tujuan = TextEditingController();

  Future<void> _simpan() async {
    final profile = ref.read(userProfileProvider).valueOrNull;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null || profile == null) return;
    if (_nama.text.trim().isEmpty || _tujuan.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection(FirestorePaths.bukuTamu()).add({
      'warga_id': user.uid,
      'nama_warga': profile.nama,
      'nomor_rumah': profile.nomorRumah ?? '',
      'nama_tamu': _nama.text.trim(),
      'tujuan': _tujuan.text.trim(),
      'check_in': FieldValue.serverTimestamp(),
      'rt_id': AppConstants.rtId,
    });
    _nama.clear();
    _tujuan.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tamu dicatat.')),
      );
    }
  }

  @override
  void dispose() {
    _nama.dispose();
    _tujuan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.bukuTamu())
        .orderBy('check_in', descending: true)
        .limit(100)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Buku Tamu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nama,
                  decoration: const InputDecoration(
                    labelText: 'Nama tamu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _tujuan,
                  decoration: const InputDecoration(
                    labelText: 'Keperluan / tujuan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _simpan,
                  child: const Text('LAPOR TAMU'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs
                    .where((doc) =>
                        (doc.data()['rt_id'] as String?) ==
                            AppConstants.rtId ||
                        doc.data()['rt_id'] == null)
                    .toList();
                if (docs.isEmpty) {
                  return const EmptyState(message: 'Belum ada tamu.');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data();
                    return AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['nama_tamu'] as String? ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text('Keperluan: ${d['tujuan'] ?? ''}'),
                          Text('Pelapor: ${d['nama_warga'] ?? ''}'),
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
