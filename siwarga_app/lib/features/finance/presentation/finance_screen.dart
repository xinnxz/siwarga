import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/application/auth_providers.dart';

String _formatTs(dynamic v) {
  if (v is Timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(v.toDate().toLocal());
  }
  return v?.toString() ?? '';
}

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;
    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.financeLedger())
        .orderBy('created_at', descending: true)
        .limit(100)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Uang Kematian / Kas')),
      floatingActionButton: admin
          ? FloatingActionButton.extended(
              onPressed: () => FinanceScreen._showTx(context),
              icon: const Icon(Icons.add),
              label: const Text('Transaksi'),
            )
          : null,
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
          num saldo = 0;
          if (docs.isNotEmpty) {
            saldo = (docs.first.data()['saldo'] as num?) ?? 0;
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppCard(
                  child: Column(
                    children: [
                      Text(
                        'Saldo saat ini',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Rp ${saldo.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: docs.isEmpty
                    ? const EmptyState(message: 'Belum ada transaksi.')
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: docs.length,
                        itemBuilder: (context, i) {
                          final d = docs[i].data();
                          final masuk = (d['masuk'] as num?) ?? 0;
                          final keluar = (d['keluar'] as num?) ?? 0;
                          final isMasuk = masuk > 0;
                          return AppCard(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(d['keterangan'] as String? ?? ''),
                                      Text(
                                        _formatTs(d['created_at']),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${isMasuk ? '+' : '-'} Rp ${isMasuk ? masuk : keluar}',
                                  style: TextStyle(
                                    color: isMasuk ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _showTx(BuildContext context) async {
    final jenis = ValueNotifier<String>('Masuk');
    final nominal = TextEditingController();
    final ket = TextEditingController();

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
            children: [
              ValueListenableBuilder<String>(
                valueListenable: jenis,
                builder: (_, j, __) => DropdownButtonFormField<String>(
                  value: j,
                  items: const [
                    DropdownMenuItem(value: 'Masuk', child: Text('Masuk')),
                    DropdownMenuItem(value: 'Keluar', child: Text('Keluar')),
                  ],
                  onChanged: (v) => jenis.value = v ?? 'Masuk',
                ),
              ),
              TextField(
                controller: nominal,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal'),
              ),
              TextField(
                controller: ket,
                decoration: const InputDecoration(labelText: 'Keterangan'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final col = FirebaseFirestore.instance
                      .collection(FirestorePaths.financeLedger());
                  final last = await col
                      .orderBy('created_at', descending: true)
                      .limit(1)
                      .get();
                  num prevSaldo = 0;
                  if (last.docs.isNotEmpty) {
                    prevSaldo =
                        (last.docs.first.data()['saldo'] as num?) ?? 0;
                  }
                  final n = num.tryParse(nominal.text) ?? 0;
                  final masuk = jenis.value == 'Masuk' ? n : 0;
                  final keluar = jenis.value == 'Keluar' ? n : 0;
                  final saldoBaru = prevSaldo + masuk - keluar;
                  await col.add({
                    'masuk': masuk,
                    'keluar': keluar,
                    'saldo': saldoBaru,
                    'keterangan': ket.text.trim(),
                    'rt_id': AppConstants.rtId,
                    'created_at': FieldValue.serverTimestamp(),
                  });
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
