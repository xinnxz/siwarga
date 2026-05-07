import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

/// Iuran per-warga — koleksi `dues_payments` + periode di `dues_periods`.
class DuesScreen extends ConsumerWidget {
  const DuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final admin = profile?.isAdmin ?? false;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Login diperlukan.')));
    }

    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.duesPayments())
        .orderBy('periode', descending: true)
        .limit(48)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Iuran')),
      floatingActionButton: admin
          ? FloatingActionButton.extended(
              onPressed: () => _buatPeriode(context),
              icon: const Icon(Icons.event_repeat),
              label: const Text('Periode'),
            )
          : null,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs.where((doc) {
            final data = doc.data();
            final rtOk = (data['rt_id'] as String?) == AppConstants.rtId ||
                data['rt_id'] == null;
            final userOk = data['user_id'] == user.uid;
            return rtOk && userOk;
          }).toList();
          if (docs.isEmpty) {
            return EmptyState(
              message: admin
                  ? 'Buat periode tagihan lewat tombol + admin.'
                  : 'Belum ada tagihan. Hubungi pengurus.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final status = d['status'] as String? ?? 'belum_bayar';
              final periode = d['periode'] as String? ?? '';
              final nominal = (d['nominal'] as num?) ?? 0;
              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(periode,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('Rp ${nominal.toStringAsFixed(0)}'),
                    Chip(label: Text(status)),
                    if (status != 'lunas' && !admin)
                      FilledButton(
                        onPressed: () => _uploadBukti(context, docs[i].id),
                        child: const Text('Upload bukti transfer'),
                      ),
                    if (admin && status == 'menunggu_verifikasi')
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => _verify(docs[i].id, true),
                            child: const Text('Terima'),
                          ),
                          TextButton(
                            onPressed: () => _verify(docs[i].id, false),
                            child: const Text('Tolak'),
                          ),
                        ],
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

  static Future<void> _uploadBukti(BuildContext context, String docId) async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x == null) return;
    final refImg = FirebaseStorage.instance
        .ref()
        .child('dues/$docId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await refImg.putData(await x.readAsBytes());
    final url = await refImg.getDownloadURL();
    await FirebaseFirestore.instance
        .doc('${FirestorePaths.duesPayments()}/$docId')
        .update({
      'bukti_transfer_url': url,
      'status': 'menunggu_verifikasi',
      'updated_at': FieldValue.serverTimestamp(),
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bukti diunggah.')),
      );
    }
  }

  static Future<void> _verify(String docId, bool accept) async {
    await FirebaseFirestore.instance
        .doc('${FirestorePaths.duesPayments()}/$docId')
        .update({
      'status': accept ? 'lunas' : 'belum_bayar',
      'verified_at': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> _buatPeriode(BuildContext context) async {
    final periode = TextEditingController();
    final nominal = TextEditingController(text: '10000');

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tagihan massal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: periode,
              decoration: const InputDecoration(
                labelText: 'Periode (mis. 2026-05)',
              ),
            ),
            TextField(
              controller: nominal,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nominal'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final p = periode.text.trim();
              final n = num.tryParse(nominal.text) ?? 0;
              if (p.isEmpty || n <= 0) return;

              final users = await FirebaseFirestore.instance
                  .collection(FirestorePaths.users())
                  .where('rt_id', isEqualTo: AppConstants.rtId)
                  .get();

              final batch = FirebaseFirestore.instance.batch();
              for (final doc in users.docs) {
                final uid = doc.id;
                final refDoc = FirebaseFirestore.instance
                    .collection(FirestorePaths.duesPayments())
                    .doc('${p}_$uid');
                batch.set(refDoc, {
                  'user_id': uid,
                  'nama_warga': doc.data()['nama'] ?? '',
                  'periode': p,
                  'nominal': n,
                  'status': 'belum_bayar',
                  'rt_id': AppConstants.rtId,
                  'created_at': FieldValue.serverTimestamp(),
                });
              }
              await batch.commit();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Buat'),
          ),
        ],
      ),
    );
  }
}
